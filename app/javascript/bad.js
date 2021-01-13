if (document.URL.match( /services\/\d+/ )) {
  function bad() {
    if(document.getElementById('bad')!=null){
      const bad_btn = document.getElementById('bad');
      if(bad_btn.getAttribute("data-load")!=null){
        return null;
      }
      bad_btn.setAttribute("data-load","true");
      bad_btn.addEventListener("click",()=>{
        const good_btn = document.getElementById('good');
        const bad_num = document.getElementById('bad-num');
        let bad_count = Number(bad_num.innerText);
        if(good_btn.getAttribute("data-check")!=="true"){
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
              bad_count++;
              bad_num.innerText = String(bad_count);
            }else if (result.bad === false) {
              bad_btn.removeAttribute("data-check");
              bad_count--;
              bad_num.innerText = String(bad_count);
            }
          };
        }
      });
    }
  }
  setInterval(bad, 1000);
}