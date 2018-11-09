# Style Transfer Machine Learning Fun

This project uses Turi Create to produce a convolutional neural network in order to apply style transfer on images. Style transfer is a technique to transfer artistic style from one image to another. 😎

You can read about the white paper on style transfer machine learning [here](https://arxiv.org/abs/1508.06576). 

## How to train your own model

* Put 1 or more images in ./trainingdata/style (A style image is an image where you want to apply it's artistic style on other images, for best result you can use the image of a painting such as Van Gohn's [Starry Night](https://www.vangoghgallery.com/painting/starry-night.html))
![starry](https://www.vangoghgallery.com/img/starry_night_full.jpg)


* Install Anaconda's python 2.7 distribution [here](https://www.anaconda.com/download/)

* Install Jupyter and Turi Create
```
pip install turicreate==5.0b2
python -m pip install --upgrade pip
python -m pip install jupyter
```

* In a new Jupyter Notebook from this project's root folder run:
```
import turicreate as tc
style = tc.load_images('./trainingdata/style')
content = tc.load_images('./trainingdata/content')
model = tc.style_transfer.create(style, content)
model.export_coreml("Style.mlmodel")

```
![jupyter](https://raw.githubusercontent.com/LunarFlash/StyleTransferMachineLearning/master/readmeImages/jupyter.png)

Then drag the model into the project, and integrate in ViewController.swift






