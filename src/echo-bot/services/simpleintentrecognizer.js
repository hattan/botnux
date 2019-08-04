class SimpleIntentRecognizer{
  
  isJoke(input){
    return input.match(/(\s|^)joke|laugh|funny(\s|$)/gi);
  }

  isWhere(input){
    return input.match(/(\s|^)where|enviornment(\s|$)/gi);
  }

  recognize(context){
    return new Promise((resolve,reject) => {
      const text = context.activity.text;

      if(this.isJoke(text)){
        resolve({ input: text, intent:'telljoke'});
      }

      if(this.isWhere(text)){
        resolve({ input: text, intent:'whereami'});
      }

      resolve({ input:text, intent:'none'});
      
    });
  }

  topIntent(res){
    return res.intent;
  }
}

module.exports =  SimpleIntentRecognizer;