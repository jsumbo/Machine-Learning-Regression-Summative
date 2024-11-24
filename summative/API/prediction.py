# prediction.py

from fastapi import FastAPI
from pydantic import BaseModel, Field
import joblib
import numpy as np

# Load model
model = joblib.load("best_model.pkl")

# Initialize FastAPI app
app = FastAPI(title="Loan Recipients Prediction API")

# Define input schema
class PredictionInput(BaseModel):
    num_loans_originated: int = Field(..., ge=0)
    loan_amount_originated: float = Field(..., ge=0)
    is_private_school: int = Field(..., ge=0, le=1)
    is_subsidized_loan: int = Field(..., ge=0, le=1)

# Define prediction endpoint
@app.post("/predict")
def predict(data: PredictionInput):
    input_data = np.array([[data.num_loans_originated, data.loan_amount_originated, 
                            data.is_private_school, data.is_subsidized_loan]])
    prediction = model.predict(input_data)[0]
    return {"predicted_recipients": int(prediction)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
