const stockForm = document.getElementById('stock-form');
const stockInput = document.getElementById('symbol');
const stockList = document.getElementById('stock-list');

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
    const stocks = data.quotes
    stockList.innerHTML = '<h3>Choose desired stock:<h3>';
    if (stocks.length > 0) {
      stocks.forEach( (stock) => {
        console.log(stock.symbol);
        const item = `<p>${stock.symbol} | ${stock.shortname} | <a href='new?symbol=${stock.symbol}&short_name=${stock.shortname}'>+</a></p>`;
        stockList.insertAdjacentHTML('beforeend', item);
      }) 
    } else {
      stockList.insertAdjacentHTML('beforeend', `<p>No stock found for "<strong>${stockInput.value}</strong>".</p>`);
    }
  });
}

const stockAutocomplete = () => {
  stockForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const stockValue = stockInput.value;
    stockList.innerHTML = '<p>searching...</p>';
    fetchYahooAutoComplete(stockValue);
  });
}

export { stockAutocomplete };
