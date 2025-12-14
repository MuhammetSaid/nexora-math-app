"""
Bot Service - Langchain ile soru çözme agent'ı
Seviyeye göre zorluk ayarlı çözüm süreleri
"""
import os
import asyncio
import json
import re
from typing import Dict, Optional
from datetime import datetime

# Langchain imports
LANGCHAIN_AVAILABLE = False
HumanMessage = None
SystemMessage = None
ChatOpenAI = None

try:
    from langchain_openai import ChatOpenAI
    print("✅ langchain_openai import edildi")
except ImportError as e:
    print(f"❌ langchain_openai import hatası: {e}")
    ChatOpenAI = None
    
try:
    # Langchain 0.1.0+ için langchain_core.messages kullan
    from langchain_core.messages import HumanMessage, SystemMessage
    print("✅ langchain_core.messages import edildi")
except ImportError as e:
    print(f"❌ langchain_core.messages import hatası: {e}")
    try:
        # Fallback: Eski versiyonlar için
        from langchain.schema import HumanMessage, SystemMessage
        print("✅ langchain.schema import edildi (eski versiyon)")
    except ImportError as e2:
        print(f"❌ langchain.schema import hatası: {e2}")
        HumanMessage = None
        SystemMessage = None

# Her iki import da başarılıysa LANGCHAIN_AVAILABLE = True
if ChatOpenAI is not None and HumanMessage is not None and SystemMessage is not None:
    LANGCHAIN_AVAILABLE = True
    print("✅ Langchain modülleri başarıyla import edildi")
else:
    print("⚠️ Bazı langchain modülleri eksik, simülasyon modu kullanılacak")


class BotService:
    """Bot servisi - Seviyeye göre akıllı soru çözme"""
    
    def __init__(self):
        """Bot servisini başlat"""
        self.llm = None
        if LANGCHAIN_AVAILABLE:
            try:
                api_key = os.getenv("OPENAI_API_KEY")
                if api_key:
                    self.llm = ChatOpenAI(
                        model="gpt-4o-mini",  # Daha hızlı ve ucuz
                        temperature=0.7,
                        openai_api_key=api_key
                    )
                    print("✅ Langchain OpenAI ile başlatıldı")
                else:
                    print("⚠️ OPENAI_API_KEY bulunamadı, simülasyon modu kullanılacak")
            except Exception as e:
                print(f"⚠️ Langchain başlatılamadı: {e}, simülasyon modu kullanılacak")
    
    def _get_thinking_messages(self) -> list:
        """Bot'un düşünme sırasında söyleyebileceği mesajlar"""
        import random
        messages = [
            "Hmm, ilginç bir soru... 🤔",
            "Bir dakika, düşüneyim... 💭",
            "Bu biraz zormuş gibi görünüyor 😅",
            "İpuçlarına bakayım... 🔍",
            "Bekle, çözüyorum... ⚙️",
            "Biraz daha zaman ver... ⏳",
            "Ah, şimdi anladım! 💡",
            "Bir saniye, hesaplıyorum... 🧮",
        ]
        return random.sample(messages, min(3, len(messages)))
    
    def _get_solved_message(self, success: bool, solve_time: float) -> str:
        """Bot'un çözdükten sonra söyleyebileceği mesajlar"""
        import random
        
        if success:
            messages = [
                f"Çözdüm! {solve_time:.1f} saniyede çözdüm! 🎉",
                f"Senden önce çözdüm! {solve_time:.1f} saniye! ⚡",
                f"Evet! Cevabı buldum! {solve_time:.1f}s'de! 💪",
                f"İşte bu! {solve_time:.1f} saniyede hallettim! 🚀",
            ]
        else:
            messages = [
                f"Hmm, bu zor geldi... 😓",
                f"Bir sonraki soruda daha iyisini yapacağım! 💪",
            ]
        return random.choice(messages)
    
    def _calculate_base_time(self, difficulty: int) -> float:
        """
        Seviyeye göre temel çözüm süresini hesaplar (saniye cinsinden)
        
        Seviye 1 (Başlangıç): 10-15 saniye (kolay, ama gerçekçi)
        Seviye 2 (Amatör): 8-12 saniye
        Seviye 3 (Orta): 7-10 saniye
        Seviye 4 (İleri): 6-9 saniye
        Seviye 5 (Uzman): 5-8 saniye (hızlı ama zor sorular için yavaş)
        """
        import random
        
        base_times = {
            1: (10.0, 15.0),  # Başlangıç: 10-15 saniye (daha gerçekçi)
            2: (8.0, 12.0),   # Amatör: 8-12 saniye
            3: (7.0, 10.0),   # Orta: 7-10 saniye
            4: (6.0, 9.0),    # İleri: 6-9 saniye
            5: (5.0, 8.0),    # Uzman: 5-8 saniye
        }
        
        min_time, max_time = base_times.get(difficulty, (7.0, 10.0))
        return random.uniform(min_time, max_time)
    
    def _extract_answer_from_text(self, text: str) -> Optional[str]:
        """Metinden cevabı çıkarır (sadece sayıları)"""
        # Sayıları bul
        numbers = re.findall(r'\d+', text)
        if numbers:
            # En uzun sayıyı al (genellikle cevap bu olur)
            return max(numbers, key=len)
        return None
    
    async def _solve_with_llm(
        self,
        hint1: str,
        hint2: str,
        solution_explanation: str,
        answer_value: str
    ) -> Optional[str]:
        """Langchain ile soruyu çözer"""
        if not self.llm:
            return None
        
        try:
            # İpuçlarını parse et (JSON formatında olabilir)
            hint1_text = hint1
            hint2_text = hint2
            explanation_text = solution_explanation
            
            try:
                hint1_json = json.loads(hint1)
                hint1_text = hint1_json.get("tr", hint1_json.get("en", hint1))
            except:
                pass
            
            try:
                hint2_json = json.loads(hint2)
                hint2_text = hint2_json.get("tr", hint2_json.get("en", hint2))
            except:
                pass
            
            try:
                explanation_json = json.loads(solution_explanation)
                explanation_text = explanation_json.get("tr", explanation_json.get("en", solution_explanation))
            except:
                pass
            
            # Prompt oluştur
            prompt = f"""Sen bir matematik bulmaca uzmanısın. Aşağıdaki ipuçlarını kullanarak soruyu çöz.

İpucu 1: {hint1_text}
İpucu 2: {hint2_text}
Çözüm Açıklaması: {explanation_text}

Sadece cevabı (sayı olarak) döndür. Başka hiçbir açıklama yapma."""

            # Mesajları oluştur (eğer import başarılıysa)
            if HumanMessage and SystemMessage:
                messages = [
                    SystemMessage(content="Sen bir matematik bulmaca çözme uzmanısın. Sadece cevabı sayı olarak ver."),
                    HumanMessage(content=prompt)
                ]
            else:
                # Fallback: dict formatında mesajlar
                messages = [
                    {"role": "system", "content": "Sen bir matematik bulmaca çözme uzmanısın. Sadece cevabı sayı olarak ver."},
                    {"role": "user", "content": prompt}
                ]
            
            response = await self.llm.ainvoke(messages)
            answer_text = response.content.strip()
            
            # Cevabı temizle
            answer = self._extract_answer_from_text(answer_text)
            return answer or answer_value  # Fallback olarak gerçek cevabı döndür
            
        except Exception as e:
            print(f"❌ LLM hatası: {e}")
            return answer_value  # Hata durumunda gerçek cevabı döndür
    
    async def solve_question(
        self,
        level_id: str,
        difficulty: int,
        hint1: str,
        hint2: str,
        solution_explanation: str,
        answer_value: str
    ) -> Dict[str, any]:
        """
        Soruyu çözer ve çözüm süresini döndürür
        
        Returns:
        {
            "answer": str,              # Bot'un cevabı
            "solve_time": float,        # Çözüm süresi (saniye)
            "success": bool,            # Başarılı mı?
            "method": str,              # "llm" veya "simulation"
            "difficulty": int,          # Zorluk seviyesi
            "thinking_messages": list,  # Düşünme sırasındaki mesajlar
            "solved_message": str       # Çözdükten sonraki mesaj
        }
        """
        start_time = datetime.now()
        
        # Temel çözüm süresini hesapla
        base_time = self._calculate_base_time(difficulty)
        
        # Düşünme mesajlarını hazırla
        thinking_messages = self._get_thinking_messages()
        
        # LLM ile çözmeyi dene
        answer = None
        method = "simulation"
        
        if self.llm:
            try:
                # Çözüm süresinin %60'ı kadar LLM işlemi yap
                llm_time = base_time * 0.6
                # İlk %30'da mesaj göster, sonra LLM çağır
                await asyncio.sleep(llm_time * 0.3)
                
                answer = await self._solve_with_llm(
                    hint1, hint2, solution_explanation, answer_value
                )
                print(f"🤖 LLM cevabı: {answer}")
                
                if answer and answer == answer_value:
                    method = "llm"
                    # LLM doğru cevabı buldu, kalan süreyi bekle (düşünme simülasyonu)
                    elapsed = (datetime.now() - start_time).total_seconds()
                    remaining_time = max(0, base_time - elapsed)
                    await asyncio.sleep(remaining_time)
                else:
                    # LLM yanlış cevap verdi, gerçek cevabı kullan ama daha uzun süre bekle
                    answer = answer_value
                    elapsed = (datetime.now() - start_time).total_seconds()
                    remaining_time = max(0, base_time * 1.3 - elapsed)
                    await asyncio.sleep(remaining_time)
            except Exception as e:
                print(f"⚠️ LLM hatası: {e}, simülasyon moduna geçiliyor")
                answer = answer_value
                # Simülasyon: düşünme süresi simüle et
                await asyncio.sleep(base_time * 0.6)  # Düşünme
                await asyncio.sleep(base_time * 0.4)  # Çözme
        else:
            # Basit simülasyon: belirli süre bekle, sonra cevabı döndür
            # Gerçekçi düşünme süresi ekle
            await asyncio.sleep(base_time * 0.6)  # Düşünme fazı
            answer = answer_value
            await asyncio.sleep(base_time * 0.4)  # Çözme fazı
        
        end_time = datetime.now()
        solve_time = (end_time - start_time).total_seconds()
        success = str(answer) == str(answer_value)
        
        # Çözüm sonrası mesajı oluştur
        solved_message = self._get_solved_message(success, solve_time)
        
        return {
            "answer": str(answer),
            "solve_time": round(solve_time, 2),
            "success": success,
            "method": method,
            "difficulty": difficulty,
            "thinking_messages": thinking_messages,
            "solved_message": solved_message
        }


# Global instance
bot_service = BotService()
