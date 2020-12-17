// const cardRegistration = () => {
//   Payjp.setPublicKey(process.env.PAYJP_PUBLIC_KEY);
//   const form = document.getElementById("registration-form");
//   form.addEventListener("submit",(e)=>{
//     e.preventDefault();

//     const formResult = document.getElementById("registration-form");
//     const formData = new FormData(formResult);

//     const card = {
//       number: formData.get("number"),
//       number: formData.get("cvc"),
//       number: formData.get("exp_month"),
//       number: `20${formData.get("exp_year")}`
//     };

//     Payjp.createToken(card, (status, response) => {
//       if(status === 200) {
//         const token = response.id;
//         const renderDom = document.getElementById("registration-form");
//         const tokenObj = `<input value=${token} type="hidden" name='card_token'>`;
//         renderDom.insertAdjacentHTML("beforeend",tokenObj);

//         document.getElementById("number").removeAttribute("name");
//         document.getElementById("cvc").removeAttribute("name");
//         document.getElementById("exp_month").removeAttribute("name");
//         document.getElementById("exp_year").removeAttribute("name");
 
//         document.getElementById("registration-form").submit();
//         document.getElementById("registration-form").reset();
//       }
//     });
//   });
// }

// window.addEventListener("load", cardRegistration);