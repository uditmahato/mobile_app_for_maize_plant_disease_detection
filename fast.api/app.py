import numpy as np
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import PlainTextResponse
import numpy as np
import io
from PIL import Image
import cv2
from keras.models import load_model
import warnings
from fastapi.middleware.cors import CORSMiddleware

warnings.filterwarnings("ignore")

model = load_model('model.h5')

# Name of Classes
target_names = ["Blight","Common_Rust","Gray_Leaf_Spot","Healthy"]


app = FastAPI(
    title="Plant Disease Detection API",
    description="""An API that utilises a Deep Learning model built with Keras(Tensorflow) to detect if a plant is healthy or suffering from Rust and Powder formation.""",
    version="0.0.1",
    debug=True,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

@app.get("/", response_class=PlainTextResponse)
async def running():
    note = """
Plant Disease Detection API 🙌🏻
Note: add "/docs" to the URL to get the Swagger UI Docs or "/redoc"
  """
    return note


favicon_path = "favicon.png"
@app.post("/predict")
async def root(file: UploadFile = File(...)):
    """
    The root function returns the prediction and confidence level of an image using a pretrained model.
    Parameters:
        file (UploadFile): The image to be predicted. 
    Returns:
        result (dict): A dictionary containing the prediction and confidence level.  
    Args:
        file:UploadFile=File(...): Specify that the file is uploaded as a multipart/form-data request
    Returns:
        The prediction and confidence level of the model in json format
    """

    #contents = io.BytesIO(await file.read())
    #file_bytes = np.asarray(bytearray(contents.read()), dtype=np.uint8)
    file_bytes = np.asarray(bytearray(await file.read()), dtype=np.uint8)
    img = cv2.imdecode(file_bytes, 1)
    
    # Resize the image to 256x256
    img = cv2.resize(img, (256, 256))
    
    # Add a batch dimension to the image
    img = np.expand_dims(img, axis=0)
    
    # Get the prediction probabilities from the model
    prediction_probabilities = model.predict(img)[0]
    
    # Get the index of the highest probability
    predicted_class_index = np.argmax(prediction_probabilities)
    
    # Get the confidence level (probability) of the prediction
    confidence_level = prediction_probabilities[predicted_class_index]
    
    # Get the class label corresponding to the predicted index
    predicted_class_label = target_names[predicted_class_index]
    
    result = {
        "prediction": predicted_class_label,
        "confidence_level": float(confidence_level)
    }
    return result
