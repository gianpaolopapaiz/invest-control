
const exportDataToExcel = (e) => {
  e.preventDefault();
  let downloadurl;
  let fileType = 'application/vnd.ms-excel';
  let tableSelect = document.getElementById('consolidated-table');
  let dataHTML = tableSelect.outerHTML.replace(/ /g, '%20');
  const filename = "tabela-consolidada.xls";
  downloadurl = document.createElement("a");
  document.body.appendChild(downloadurl);
  if(navigator.msSaveOrOpenBlob){
    var blob = new Blob(['\ufeff', dataHTML],
      {
        type:  fileType
      });
    navigator.msSaveOrOpenBlob( blob, filename);
    }
  else {
    downloadurl.href = 'data:' + fileType + ', ' + dataHTML;
    downloadurl.download = filename;
    downloadurl.click();
  }
}

export {exportDataToExcel}