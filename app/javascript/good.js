function good() {
  if(document.getElementById('good')!=null){
    const good_btn = document.getElementById('good');
    if(good_btn.getAttribute("data-load")!=null){
      return null;
    }
    good_btn.setAttribute("data-load","true");
    good_btn.addEventListener("click",()=>{
      const bad_btn = document.getElementById('bad');
      const good_num = document.getElementById('good-num');
      let good_count = Number(good_num.innerText);
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
            good_count++;
            good_num.innerText = String(good_count);
          }else if (result.good === false) {
            good_btn.removeAttribute("data-check");
            good_count--;
            good_num.innerText = String(good_count);

          }
        };
      }
    });
  }
}

setInterval(good, 1000);