Class dc.imageeditor.ImageEditorRESTApp Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<!-- Server Info -->
<Route Url="/" Method="GET" Call="GetInfo" Cors="true"/>
<!-- Swagger specs -->
<Route Url="/_spec" Method="GET" Call="SwaggerSpec" />

<!-- do a thumbnail -->
<Route Url="/thumbnail" Method="POST" Call="DoThumbnail" />

<!-- do a watermark -->
<Route Url="/watermark" Method="POST" Call="DoWatermark" />

<!-- do a image filter -->
<Route Url="/filter" Method="POST" Call="DoFilter" />

</Routes>
}

/// Do thumbnail
ClassMethod DoThumbnail() As %Status
{
    Set tSC = $$$OK
    
    try {
        // get the file from the multipart request
        Set source = %request.GetMimeData("file")
        
        // save the file to the input folder, to be processed with imageai
        Set destination=##class(%Stream.FileBinary).%New()
        Set destination.Filename="/opt/irisbuild/input/"_source.FileName
        set tSC=destination.CopyFrom(source) //reader open the file
        set result=destination.%Save()
        
        //call embedded python classmethod to thumbnail the image
        Do ##class(dc.imageeditor.ImageEditorService).DoThumbnail(source.FileName)

        If ($FIND(source.FileName, "jpg") > 0) || ($FIND(source.FileName, "jpeg") > 0) {
          Set %response.ContentType = "image/jpeg"
        } ElseIf ($FIND(source.FileName, "png") > 0) {
          Set %response.ContentType = "image/png"
        } Else {
          Set %response.ContentType = "application/octet-stream"
        }

        Do %response.SetHeader("Content-Disposition","attachment;filename="""_source.FileName_"""")
        Set %response.NoCharSetConvert=1
        Set %response.Headers("Access-Control-Allow-Origin")="*"

        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile("/opt/irisbuild/output/"_source.FileName)
        Do stream.OutputToDevice()
         
        Set tSC=$$$OK
    
    //returns error message to the user
    } catch e {
        Set tSC=e.AsStatus()
        Set pOutput = tSC
    }

    Quit tSC
}

/// Do Watermark
ClassMethod DoWatermark() As %Status
{
    Set tSC = $$$OK
    
    try {
        // get the file from the multipart request
        Set source = %request.GetMimeData("file")

        Set watermark = $Get(%request.Data(("watermark"),1))
        
        // save the file to the input folder, to be processed with image editor
        Set destination=##class(%Stream.FileBinary).%New()
        Set destination.Filename="/opt/irisbuild/input/"_source.FileName
        set tSC=destination.CopyFrom(source) //reader open the file
        set result=destination.%Save()
        
        //call embedded python classmethod to thumbnail the image
        Do ##class(dc.imageeditor.ImageEditorService).DoWatermark(source.FileName, watermark)

        If ($FIND(source.FileName, "jpg") > 0) || ($FIND(source.FileName, "jpeg") > 0) {
          Set %response.ContentType = "image/jpeg"
        } ElseIf ($FIND(source.FileName, "png") > 0) {
          Set %response.ContentType = "image/png"
        } Else {
          Set %response.ContentType = "application/octet-stream"
        }

        Do %response.SetHeader("Content-Disposition","attachment;filename="""_source.FileName_"""")
        Set %response.NoCharSetConvert=1
        Set %response.Headers("Access-Control-Allow-Origin")="*"

        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile("/opt/irisbuild/output/"_source.FileName)
        Do stream.OutputToDevice()
         
        Set tSC=$$$OK
    
    //returns error message to the user
    } catch e {
        Set tSC=e.AsStatus()
        Set pOutput = tSC
    }

    Quit tSC
}

/// Do filter
ClassMethod DoFilter() As %Status
{
    Set tSC = $$$OK
    
    try {
        // get the file from the multipart request
        Set source = %request.GetMimeData("file")

        Set filter = $Get(%request.Data(("filter"),1))
        
        // save the file to the input folder, to be processed with image editor
        Set destination=##class(%Stream.FileBinary).%New()
        Set destination.Filename="/opt/irisbuild/input/"_source.FileName
        set tSC=destination.CopyFrom(source) //reader open the file
        set result=destination.%Save()
        
        //call embedded python classmethod to thumbnail the image
        Do ##class(dc.imageeditor.ImageEditorService).DoFilter(source.FileName, filter)

        If ($FIND(source.FileName, "jpg") > 0) || ($FIND(source.FileName, "jpeg") > 0) {
          Set %response.ContentType = "image/jpeg"
        } ElseIf ($FIND(source.FileName, "png") > 0) {
          Set %response.ContentType = "image/png"
        } Else {
          Set %response.ContentType = "application/octet-stream"
        }

        Do %response.SetHeader("Content-Disposition","attachment;filename="""_source.FileName_"""")
        Set %response.NoCharSetConvert=1
        Set %response.Headers("Access-Control-Allow-Origin")="*"

        Set stream=##class(%Stream.FileBinary).%New()
        Set sc=stream.LinkToFile("/opt/irisbuild/output/"_source.FileName)
        Do stream.OutputToDevice()
         
        Set tSC=$$$OK
    
    //returns error message to the user
    } catch e {
        Set tSC=e.AsStatus()
        Set pOutput = tSC
    }

    Quit tSC
}

/// General information
ClassMethod GetInfo() As %Status
{
  SET version = ..#Version
  SET fmt=##class(%SYS.NLS.Format).%New("ptbw")
  
  SET info = {
    "Service": "Image Editor API",
    "version": (version),
    "Developer": "Yuri Gomes",
    "Status": "Ok",
    "Date": ($ZDATETIME($HOROLOG))
  }
  Set %response.ContentType = ..#CONTENTTYPEJSON
  Set %response.Headers("Access-Control-Allow-Origin")="*"

  Write info.%ToJSON()
  Quit $$$OK
}

ClassMethod SwaggerSpec() As %Status
{
  Set tSC = ##class(%REST.API).GetWebRESTApplication($NAMESPACE, %request.Application, .swagger)
  Do swagger.info.%Remove("x-ISC_Namespace")
  Set swagger.basePath = "/iris-tts" 
  Set swagger.info.title = "TTS Service API"
  Set swagger.info.version = "1.0"
  Set swagger.host = "localhost:52773"
  Return ..%ProcessResult($$$OK, swagger)
}

ClassMethod %ProcessResult(pStatus As %Status = {$$$OK}, pResult As %DynamicObject = "") As %Status [ Internal ]
{
  #dim %response As %CSP.Response
  SET tSC = $$$OK
  IF $$$ISERR(pStatus) {
    SET %response.Status = 500
    SET tSC = ..StatusToJSON(pStatus, .tJSON)
    IF $isobject(tJSON) {
      SET pResult = tJSON
    } ELSE {
      SET pResult = { "errors": [ { "error": "Unknown error parsing status code" } ] }
    }
  } 
  ELSEIF pStatus=1 {
    IF '$isobject(pResult){
      SET pResult = {
      }
    }
  }
  ELSE {
    SET %response.Status = pStatus
    SET error = $PIECE(pStatus, " ", 2, *)
    SET pResult = {
      "error": (error)
    }
  }
  
  IF pResult.%Extends("%Library.DynamicAbstractObject") {
    WRITE pResult.%ToJSON()
  }
  ELSEIF pResult.%Extends("%JSON.Adaptor") {
    DO pResult.%JSONExport()
  }
  ELSEIF pResult.%Extends("%Stream.Object") {
    DO pResult.OutputToDevice()
  }
  
  QUIT tSC
}

}
