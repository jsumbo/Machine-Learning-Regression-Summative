from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import numpy as np

# Load the model
with open("best_model.pkl", "rb") as file:
    model = pickle.load(file)

# FastAPI setup
app = FastAPI()

# Define the input schema
class LoanPredictionInput(BaseModel):
    mean_earnings: float

@app.post("/predict")
def predict(input_data: LoanPredictionInput):
    # Prepare data for prediction
    data = np.array([[input_data.mean_earnings]])
    prediction = model.predict(data)[0]
    return {"predicted_recipients": int(prediction)}
