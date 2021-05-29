
const fetchYahooAutoComplete = (value) => {
  fetch(`https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q=${value}`, {
    "method": "GET",
    "headers": {
      "x-rapidapi-key": "0d23aa15ccmsh08742d5ddc98f33p18f9dbjsnd790f2c04382",
      "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
    }
  })
.then(response => response.json())
.then(data => {
  
  console.log(data.quotes);
  const stockList = document.getElementById('stock-list');
  stockList.innerHTML = '';
  data.quotes.forEach( (stock) => {
    console.log(stock.symbol);
    const item = `<p>${stock.symbol} | ${stock.shortname} | <a href='#'>+</a></p>`;
    stockList.insertAdjacentHTML('beforeend', item);
  }) 
});
}

const stockAutocomplete = () => {
  const stockForm = document.getElementById('stock-form');
  const stockInput = document.getElementById('symbol');
  stockForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const stockValue = stockInput.value;
    fetchYahooAutoComplete(stockValue);
  });
}

export { stockAutocomplete };
