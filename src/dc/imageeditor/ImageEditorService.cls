/// Image processing services
Class dc.imageeditor.ImageEditorService
{

ClassMethod DoThumbnail(Image As %String) As %Status
{
        Do ..ProcessThumbnail(Image)
        Quit $$$OK
}

/// get thumbnail for the image
ClassMethod ProcessThumbnail(imageName) [ Language = python ]
{
        #Import required Image library
        from PIL import Image

        # set folder to receive the image to be processed
        input_path = "/opt/irisbuild/input/" + imageName
        # set folder to stores the results (image processed)
        output_path = "/opt/irisbuild/output/" + imageName

        # open the original image
        image = Image.open(input_path)
        # reduce image size
        image.thumbnail((90,90))
        # save the new image
        image.save(output_path)
}

ClassMethod DoWatermark(Image As %String, Watermark As %String) As %Status
{
        Do ..ProcessWartermarker(Image, Watermark)
        Quit $$$OK
}

/// do a watermark for the image
ClassMethod ProcessWartermarker(imageName, watermark) [ Language = python ]
{
        #Import required Image library
        from PIL import Image, ImageDraw, ImageFont

        # set folder to receive the image to be processed
        input_path = "/opt/irisbuild/input/" + imageName
        # set folder to stores the results (image processed)
        output_path = "/opt/irisbuild/output/" + imageName

        # open the original image
        im = Image.open(input_path)
        
        # extract image dimensions
        width, height = im.size

        # get drawer
        draw = ImageDraw.Draw(im)
        
        # get text writer
        font = ImageFont.truetype("DejaVuSans.ttf", 32)
        textwidth, textheight = draw.textsize(watermark, font)

        # calculate the x,y coordinates of the text
        margin = 10
        x = width - textwidth - margin
        y = height - textheight - margin
        
        # draw watermark in the bottom right corner
        draw.text((x, y), watermark, font=font)
        
        # save the new image
        im.save(output_path)
}

ClassMethod DoFilter(Image As %String, Filter As %String) As %Status
{
        Do ..ProcessFilter(Image, Filter)
        Quit $$$OK
}

/// apply a filter in the image
ClassMethod ProcessFilter(imageName, filter) [ Language = python ]
{
        #Import required Image library
        from PIL import Image, ImageFilter

        #Import all the enhancement filter from pillow
        from PIL.ImageFilter import (
        BLUR, CONTOUR, DETAIL, EDGE_ENHANCE, EDGE_ENHANCE_MORE,
        EMBOSS, FIND_EDGES, SMOOTH, SMOOTH_MORE, SHARPEN
        )

        # set folder to receive the image to be processed
        input_path = "/opt/irisbuild/input/" + imageName
        # set folder to stores the results (image processed)
        output_path = "/opt/irisbuild/output/" + imageName

        # open the original image
        im = Image.open(input_path)
        
        if filter == "BLUR":
                imFiltered = im.filter(BLUR)
        elif filter == "CONTOUR":
                imFiltered = im.filter(CONTOUR)
        elif filter == "DETAIL":
                imFiltered = im.filter(DETAIL)
        elif filter == "EDGE_ENHANCE":
                imFiltered = im.filter(CONTOUR)
        elif filter == "EDGE_ENHANCE_MORE":
                imFiltered = im.filter(EDGE_ENHANCE_MORE)
        elif filter == "EMBOSS":
                imFiltered = im.filter(EMBOSS)
        elif filter == "FIND_EDGES":
                imFiltered = im.filter(FIND_EDGES)
        elif filter == "SHARPEN":
                imFiltered = im.filter(SHARPEN)
        elif filter == "SMOOTH":
                imFiltered = im.filter(SMOOTH)
        elif filter == "SMOOTH_MORE":
                imFiltered = im.filter(SMOOTH_MORE)
        else:   
                imFiltered = im
        # save the new image
        imFiltered.save(output_path)
}

}
