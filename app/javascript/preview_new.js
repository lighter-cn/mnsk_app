if (document.URL.match( /services/ )&&document.URL.match( /new/ )) {
  document.addEventListener('DOMContentLoaded', function(){
    const ImageList = document.getElementById('image-list');

    let imageElementNum = 1;

    const createImageHTML = (blob,number) => {
       // 画像を表示するためのdiv要素を生成
      const img_up = document.getElementById('img-up');
      const imageElement = document.createElement('div');
      imageElement.setAttribute('class', "image-element");
      imageElement.setAttribute('id', `image-element_${number}`);

      // 表示する画像を生成
      const blobImage = document.createElement('img');
      blobImage.setAttribute('src', blob);

      // ファイル選択ボタンを生成
      const inputHTML = document.createElement('input')
      imageElementNum += 1;
      inputHTML.setAttribute('id', `service_image_${imageElementNum}`)
      inputHTML.setAttribute('name', 'service[images][]')
      inputHTML.setAttribute('type', 'file')

      // 削除ボタン追加
      const deleteBtn = document.createElement('button');
      deleteBtn.setAttribute('class','img_delete_bnt');
      deleteBtn.innerText = "削除";

      deleteBtn.addEventListener('click',(e)=>{
        e.preventDefault();
        remove_content = document.getElementById(`image-element_${number}`);
        remove_content.remove();
      });


      // 生成したHTMLの要素をブラウザに表示させる
      imageElement.appendChild(blobImage);
      input_id=document.getElementById(`service_image_${number}`)
      imageElement.appendChild(input_id);
      input_id.setAttribute('class','hidden');
      imageElement.appendChild(deleteBtn);
      ImageList.appendChild(imageElement);
      img_up.appendChild(inputHTML);

      inputHTML.addEventListener('change', (e) => {
        createImageHTML(window.URL.createObjectURL(e.target.files[0]),imageElementNum)
      })
    };

    document.getElementById('service_image_0').addEventListener('change', function(e){
      createImageHTML(window.URL.createObjectURL(e.target.files[0]),0);
    });
  });
}