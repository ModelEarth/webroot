
// enable type-hints
/// <reference types="../dist/useeio" />
/** @type {import('useeio')} */
var useeio = useeio;

/*
const model = useeio.modelOf({
  endpoint: 'http://localhost:8080/api',
  model: 'USEEIOv2.0',
  asJsonFiles: true,
});
*/

/*
// Public API Discontinued. Use asJsonFiles instead.
const model = useeio.modelOf({
  endpoint: 'https://smmtool.app.cloud.gov/api',
  model: 'USEEIOv2.0.1-411',
  asJsonFiles: false,
});
*/
let model = getModel();
function getModelFolderName() {
    let hash = getUrlHash();
    let theModel = "USEEIOv2.0.1-411";
    if (hash.state) { // Prior to 2024 states were GA, ME, MN, OR, WA
        let thestate = hash.state.split(",")[0].toUpperCase();
        theModel = thestate + "EEIOv1.0-s-20"
    }
    return theModel;
}
function getModel() {
    let theModel = getModelFolderName()
    return useeio.modelOf({ // Calls the getJson() method set in webapi.ts
      //endpoint: 'http://localhost:8887/useeio-json/models/2020',

      // So clone the useeio-json repo into the same webroot.
      endpoint: '/useeio-json/models/2020',

      // CORS error
      endpoint: 'https://model.earth/useeio-json/main/models/2020',
      endpoint: 'https://raw.githubusercontent.com/ModelEarth/useeio-json/main/models/2020',
      
      model: theModel,
      asJsonFiles: true,
    });
}

// Common dropdown functionality for locale and number format
function initializeDropdowns() {
  // Populate the locale dropdown
  var localeSelect = document.getElementById("locale-select");
  if (localeSelect) {
    var locales = ["en-US", "fr-FR", "de-DE", "es-ES", "it-IT", "ja-JP", "ko-KR", "zh-CN"];
    
    locales.forEach(locale => {
        let option = document.createElement("option");
        option.value = locale;
        option.textContent = locale;
        localeSelect.appendChild(option);
    });
    
    // Set the dropdown to the user's current locale
    localeSelect.value = navigator.language;
  }

  // Populate the number format dropdown
  let numberFormatSelect = document.getElementById("number-format-select");
  if (numberFormatSelect) {
    let formats = ["simple", "full", "scientific"];
    formats.forEach(format => {
        let option = document.createElement("option");
        option.value = format;
        option.textContent = format;
        numberFormatSelect.appendChild(option);
    });
    
    // Set default to simple
    numberFormatSelect.value = "simple";
  }
}

// Number formatting function based on format type
function formatNumber(value, formatType, locale = navigator.language) {
  if (!value && value !== 0) return '';
  
  switch(formatType) {
    case "full":
      return new Intl.NumberFormat(locale).format(value);
    case "scientific":
      let scientificValue = Number(value).toExponential(3);
      let parts = scientificValue.split("e");
      let base = parts[0];
      let exponent = parts[1];
      if (exponent) {
        return `${base}&times;10<sup>${exponent.replace('+', '')}</sup>`;
      }
      return scientificValue;
    case "simple":
    default:
      return formatCell(value); // Use existing formatCell function
  }
}

// Get current number format selection
function getCurrentNumberFormat() {
  const select = document.getElementById("number-format-select");
  return select ? select.value : "simple";
}

// Get current locale selection
function getCurrentLocale() {
  const select = document.getElementById("locale-select");
  return select ? select.value : navigator.language;
}
// NOT USED - Will probably delete. Tabulator Intl.NumberFormat used instead.
function formatNum(numberString, locale = navigator.language) {
    if (typeof numberString !== 'string') {
        numberString = String(numberString);
    }
    // Remove existing formatNum or periods
    let cleanString = numberString.replace(/[,.]/g, '');
    
    // Check if the cleaned string is a valid number
    if (isNaN(cleanString)) {
        return numberString; // Return the original string if it's not a valid number
    }
    // Check if the locale is valid; default to 'en-US' if not
    if (!locale || typeof locale !== 'string' || !Intl.NumberFormat.supportedLocalesOf([locale]).length) {
        locale = 'en-US';
    }
    // Convert to a number
    let number = parseFloat(cleanString);
    
    // Format the number based on the locale
    return number.toLocaleString(locale);
}
/*
// US standard (default)
console.log(formatNum("1234567.89")); // Output: "1,234,567.89"

// German standard
console.log(formatNum("1234567,89", 'de-DE')); // Output: "1.234.567,89"

// French standard
console.log(formatNum("1234567.89", 'fr-FR')); // Output: "1 234 567,89"

// Invalid number string remains unchanged
console.log(formatNum("12a34567.89")); // Output: "12a34567.89"

// Number with existing formatNum/periods
console.log(formatNum("1,234,567.89", 'en-US')); // Output: "1,234,567.89"
console.log(formatNum("1.234.567,89", 'de-DE')); // Output: "1.234.567,89"
*/

function getUrlHash() {
  return (function (pairs) {
    if (pairs == "") return {};
    var result = {};
    pairs.forEach(function(pair) {
      // Split the pair on "=" to get key and value
      var keyValue = pair.split('=');
      var key = keyValue[0];
      var value = keyValue.slice(1).join('=');

      // Replace "%26" with "&" in the value
      value = value.replace(/%26/g, '&');

      // Set the key-value pair in the result object
      result[key] = value;
    });
    return result;
  })(window.location.hash.substr(1).split('&'));
}
