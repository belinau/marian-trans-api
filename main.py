from fastapi import FastAPI
from pydantic import BaseModel
from transformers import MarianMTModel, MarianTokenizer

app = FastAPI()

model_name = "Helsinki-NLP/opus-mt-en-sl"
tokenizer = MarianTokenizer.from_pretrained(model_name)
model = MarianMTModel.from_pretrained(model_name)

class TranslationRequest(BaseModel):
    text: str

@app.post("/translate/")
def translate(request: TranslationRequest):
    inputs = tokenizer(request.text, return_tensors="pt", padding=True)
    output_tokens = model.generate(**inputs)
    translation = tokenizer.decode(output_tokens[0], skip_special_tokens=True)
    return {"translation": translation}
