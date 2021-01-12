function good() {
  const good_btn = document.getElementById('good');
  if(good_btn.getAttribute("data-load")!=null){
    return null;
  }
  good_btn.setAttribute("data-load","true");
  good_btn.addEventListener("click",()=>{
    const bad_btn = document.getElementById('bad');
    if(bad_btn.getAttribute("data-check")!=="true"){
      const orderId = good_btn.getAttribute("order-id");
      const serviceId = good_btn.getAttribute("service-id");
      const XHR = new XMLHttpRequest();
      XHR.open("GET", `/services/${serviceId}/orders/${orderId}/good`,true);
      XHR.responseType = "json";
      XHR.send();
      XHR.onload = () => {
        if(XHR.status != 200){
          alert(`Error ${XHR.status}: ${XHR.statusText}`);
          return null;
        }
        const result = XHR.response.order;
        if(result.good === true){
          good_btn.setAttribute("data-check","true");
        }else if (result.good === false) {
          good_btn.removeAttribute("data-check");
        }
      };
    }
  });
}
setInterval(good, 1000);