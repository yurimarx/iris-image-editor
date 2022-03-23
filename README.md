# iris-image-editor
IRIS and Python libraries working toghether to image processing procedures

## Installation
1. Clone/git pull the repo into any local directory

```
$ git clone https://github.com/yurimarx/iris-image-editor.git
```

2. Open a Docker terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container:

```
$ docker-compose up -d 
```

4. Do to thumbnail: Go to your Postman (or other similar REST client) and config the request like this image, send and view the response:

![Request for Thumbnail images](https://github.com/yurimarx/iris-image-editor/raw/main/thumbmail.png "Request for Thumbnail images")

- Method: POST
- URL: http://localhost:52773/iris-image-editor/thumbnail 
- Body: form-data
- Key: file (the name of file field must be file) and type File
- Value: file from your computer 

5. To do watermark: Go to your Postman (or other similar REST client) and config the request like this image, send and view the response:

![Request for watermark images](https://github.com/yurimarx/iris-image-editor/raw/main/watermark.png "Request for watermark images")

- Method: POST
- URL: http://localhost:52773/iris-image-editor/watermark 
- Body: form-data
- Key: file (the name of file field must be file) and type File 
- Value: file from your computer
- Key: watermark (text to be wrote inside image) and type text 
- Value: I'm a cat (or other value you want)

6. To do filters: Go to your Postman (or other similar REST client) and config the request like this image, send and view the response:

![Request for filter images](https://github.com/yurimarx/iris-image-editor/raw/main/filter.png "Request for filter images")

- Method: POST
- URL: http://localhost:52773/iris-image-editor/filter 
- Body: form-data
- Key: file (the name of file field must be file) and type File 
- Value: file from your computer
- Key: filter (filter option to be selected) and type text 
- Value: BLUR, CONTOUR, DETAIL, EDGE_ENHANCE, EDGE_ENHANCE_MORE,
        EMBOSS, FIND_EDGES, SMOOTH, SMOOTH_MORE or SHARPEN

# Credits
This application used Pillow library (https://pillow.readthedocs.io/en/stable/)
