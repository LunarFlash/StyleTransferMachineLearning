# Style Transfer Machine Learning Fun

This project uses Turi Create to produce a convolutional neural network in order to apply style tranfer against images. Style transfer is a technique to transfer artistic style from 1 image to another. 😎

## How to use

* Install Anaconda's python 2.7 distribution [here](https://www.anaconda.com/download/)

* Install Jupyter and Turi Create
```
pip install turicreate==5.0b2
python -m pip install --upgrade pip
python -m pip install jupyter
```

* In a new Jupyter Notebook run:
```
import turicreate as tc
style = tc.load_images('./trainingdata/style')
content = tc.load_images('./trainingdata/content')
model = tc.style_transfer.create(style, content)
model.export_coreml("Style.mlmodel")

```

Then drag the model into the project, and integrate in ViewController.swift






