function check(){
  word_value = document.getElementById('tango').value;
  meaning_value = document.getElementById('mean').value;
  synonym_value = document.getElementById('syn').value;
  sentence_value = document.getElementById('sntnc').value;

  regObj = new RegExp(/<("[^"]*"|'[^']*'|[^'">])*>/, "g");
  result1 = word_value.match(regObj);
  result2 = meaning_value.match(regObj);
  result3 = synonym_value.match(regObj);
  result4 = sentence_value.match(regObj);


  if(word_value.length <= 0 && meaning_value.length <= 0){
    ret = false; alert("単語と意味は必須です.");
  }else if(result1){
    ret = false; alert("HTMLタグは使えません");
  }else if(result2){
    ret = false; alert("HTMLタグは使えません");
  }else if(result3){
    ret = false; alert("HTMLタグは使えません");
  }else if(result4){
    ret = false; alert("HTMLタグは使えません");
  }else{
    ret = true;
  }
  return ret;
}

function check2(){
  word_value = document.getElementById('tango').value;
  regObj = new RegExp(/<("[^"]*"|'[^']*'|[^'">])*>/, "g");
  result1 = word_value.match(regObj);
  if (result1){
    ret = false; alert("HTMLタグは使えません");
  }
  else{
    ret = true;
  }
  return ret
}
