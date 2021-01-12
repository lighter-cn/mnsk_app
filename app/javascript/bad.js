function bad() {
  const bad_btn = document.getElementById('bad');
  if(bad_btn.getAttribute("data-load")!=null){
    return null;
  }
  bad_btn.setAttribute("data-load","true");
  bad_btn.addEventListener("click",()=>{
    const orderId = bad_btn.getAttribute("order-id");
    const serviceId = bad_btn.getAttribute("service-id");
    const XHR = new XMLHttpRequest();
    XHR.open("GET", `/services/${serviceId}/orders/${orderId}/bad`,true);
    XHR.responseType = "json";
    XHR.send();
    XHR.onload = () => {
      if(XHR.status != 200){
        alert(`Error ${XHR.status}: ${XHR.statusText}`);
        return null;
      }
      const result = XHR.response.order;
      if(result.bad === true){
        bad_btn.setAttribute("data-check","true");
      }else if (result.bad === false) {
        bad_btn.removeAttribute("data-check");
      }
    };
  });
}
setInterval(bad, 1000);