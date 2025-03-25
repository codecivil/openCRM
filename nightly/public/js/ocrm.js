//data is a base64 string
function exportXMLBase64(filename,data) {
    let _download = document.createElement('a')
    _download.href = "data:text/xml;charset=utf-8;base64,"+data;
    _download.download = filename+".xml";
    _download.click();
}
