// Displays a label for food nutrition or product impact.
// profileObject is built by createProfileObject() in layout-.js template.

document.addEventListener('hashChangeEvent', hashChangedProfile, false);
function hashChangedProfile() {
    console.log("Profile hash changed");
    loadProfile();
}
loadProfile();

let menuItems = []; // { profileObject, quantity }
let aggregateProfile = {};
let searchResults = []; // Store current search results

document.addEventListener('DOMContentLoaded', function() {
    addUSDASearchBar();
});

function addUSDASearchBar() {
    let searchDiv = document.getElementById("usda-search-div");
    if (searchDiv && !searchDiv.innerHTML.trim()) {
        searchDiv.style.marginBottom = "1em";
        searchDiv.innerHTML = `
            <input type="text" id="usda-search-input" placeholder="Search USDA Food Database" style="width:300px;">
            <button id="usda-search-button">Search</button>
        `;
    }
    document.getElementById("usda-search-button").onclick = function() {
        const query = document.getElementById("usda-search-input").value.trim();
        searchUSDAFood(query);
    };
    document.getElementById("usda-search-input").addEventListener("keypress", function(e) {
        if (e.key === "Enter") {
            document.getElementById("usda-search-button").click();
        }
    });
}

function searchUSDAFood(query = "apple") {
    const apiKey = "bLecediTVa2sWd8AegmUZ9o7DxYFSYoef9B4i1Ml";
    const apiUrl = `https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${apiKey}&query=${encodeURIComponent(query)}&pageSize=10&pageNumber=1`;
    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            if (data.foods && data.foods.length > 0) {
                searchResults = data.foods;
                displaySearchResults();
            } else {
                console.log('No foods found for query:', query);
                clearSearchResults();
            }
        })
        .catch(error => {
            console.error('Error fetching USDA data:', error);
            clearSearchResults();
        });
}

function displaySearchResults() {
    const container = document.getElementById("search-results-container");
    container.innerHTML = "<h3>Search Results - Click to Add to Menu:</h3>";

    searchResults.forEach((food, index) => {
        const resultDiv = document.createElement("div");
        resultDiv.className = "search-result-item";
        resultDiv.innerHTML = `
            <div class="food-info">
                <strong>${food.description}</strong>
                <br><small>Brand: ${food.brandOwner || 'Generic'}</small>
                <br><small>Category: ${food.foodCategory || 'N/A'}</small>
            </div>
            <button class="add-to-menu-btn" data-index="${index}">Add to Menu</button>
        `;
        container.appendChild(resultDiv);
    });

    // Add event listeners for "Add to Menu" buttons
    container.querySelectorAll(".add-to-menu-btn").forEach(button => {
        button.onclick = function() {
            const index = parseInt(button.dataset.index);
            addFoodToMenu(searchResults[index]);
        };
    });
}

function clearSearchResults() {
    const container = document.getElementById("search-results-container");
    container.innerHTML = "";
}

function addFoodToMenu(food) {
    // Check if food is already in menu
    const existingIndex = menuItems.findIndex(item =>
        item.profileObject.itemName === food.description
    );

    if (existingIndex >= 0) {
        // Increase quantity if already in menu
        menuItems[existingIndex].quantity++;
    } else {
        // Add new item to menu
        menuItems.push({
            profileObject: usdaProfileObject(food),
            quantity: 1,
        });
    }

    renderMenuLabels();
}

function usdaProfileObject(usdaItem) {
    const nutrients = {};
    (usdaItem.foodNutrients || []).forEach(nutrient => {
        if (nutrient.nutrientName && nutrient.value !== undefined) {
            nutrients[nutrient.nutrientName] = nutrient.value;
        }
    });

    // Handle energy/calories
    let calories = 0;
    (usdaItem.foodNutrients || []).forEach(nutrient => {
        if ((nutrient.nutrientName === "Energy" || nutrient.nutrientName === "Calories") && nutrient.unitName === "KCAL") {
            calories = nutrient.value;
        }
    });

    // Create a more flexible lookup that tries multiple possible names
    const getValue = (possibleNames) => {
        for (let name of possibleNames) {
            if (nutrients[name] !== undefined) {
                return nutrients[name];
            }
        }
        return 0;
    };

    return {
        itemName: usdaItem.description,
        sections: [
            { name: "Calories", value: calories },
            {
                name: "Calories from Fat",
                value: getValue(["Total lipid (fat)"]) * 9
            },
            {
                name: "Total Fat",
                value: getValue(["Total lipid (fat)", "Fat", "Total Fat"]),
                dailyValue: calculateDailyValue(getValue(["Total lipid (fat)", "Fat", "Total Fat"]), 'fat'),
                subsections: [
                    {
                        name: "Saturated Fat",
                        value: getValue(["Fatty acids, total trans"]),
                        dailyValue: calculateDailyValue(getValue(["Fatty acids, total saturated", "Saturated Fat"]), 'satFat')
                    },
                    {
                        name: "Trans Fat",
                        value: getValue(["Fatty acids, total trans", "Trans Fat"])
                    }
                ]
            },
            {
                name: "Cholesterol",
                value: getValue(["Cholesterol"]),
                dailyValue: calculateDailyValue(getValue(["Cholesterol"]), 'cholesterol')
            },
            {
                name: "Sodium",
                value: getValue(["Sodium, Na", "Sodium"]),
                dailyValue: calculateDailyValue(getValue(["Sodium, Na", "Sodium"]), 'sodium')
            },
            {
                name: "Total Carbohydrate",
                value: getValue(["Carbohydrate, by difference"]),
                dailyValue: calculateDailyValue(getValue(["Carbohydrate, by difference", "Total Carbohydrate", "Carbohydrates"]), 'carb'),
                subsections: [
                    {
                        name: "Dietary Fiber",
                        value: getValue(["Fiber, total dietary", "Dietary Fiber", "Fiber"]),
                        dailyValue: calculateDailyValue(getValue(["Fiber, total dietary", "Dietary Fiber", "Fiber"]), 'fiber')
                    },
                    {
                        name: "Sugars",
                        value: getValue(["Total Sugars", "Sugars, total including NLEA", "Sugars"])
                    }
                ]
            },
            { name: "Protein", value: getValue(["Protein"]) },
            {
                name: "Vitamin D",
                value: getValue(["Vitamin D (D2 + D3)", "Vitamin D"]),
                dailyValue: calculateDailyValue(getValue(["Vitamin D (D2 + D3)", "Vitamin D"]), 'vitaminD')
            },
            {
                name: "Potassium",
                value: getValue(["Potassium, K", "Potassium"]),
                dailyValue: calculateDailyValue(getValue(["Potassium, K", "Potassium"]), 'potassium')
            },
            {
                name: "Calcium",
                value: getValue(["Calcium, Ca", "Calcium"]),
                dailyValue: calculateDailyValue(getValue(["Calcium, Ca", "Calcium"]), 'calcium')
            },
            {
                name: "Iron",
                value: getValue(["Iron, Fe", "Iron"]),
                dailyValue: calculateDailyValue(getValue(["Iron, Fe", "Iron"]), 'iron')
            },
            { name: "Added Sugars", value: 0, dailyValue: null },
            { name: "Caffeine", value: getValue(["Caffeine"]) }
        ]
    };
}

function renderMenuLabels() {
    const container = document.getElementById("menu-container");
    container.innerHTML = "";

    // Only show aggregate if there are menu items
    if (menuItems.length > 0) {
        updateAggregateProfile();
        container.appendChild(renderNutritionLabel(aggregateProfile, 1, true));
    }
    
    menuItems.forEach((item, idx) => {
        const itemDiv = document.createElement("div");
        itemDiv.classList.add("menu-label");
        itemDiv.innerHTML = `
            <div class="menu-item-header">
                <h4>${item.profileObject.itemName}</h4>
                <button class="remove-item-btn" data-idx="${idx}">Remove</button>
            </div>
        `;
        const controls = document.createElement("div");
        controls.className = "quantity-controls";
        controls.innerHTML = `
            <button class="decrease-qty" data-idx="${idx}">-</button>
            <input type="number" min="1" value="${item.quantity}" class="qty-input" data-idx="${idx}" style="width:40px";>
            <button class="increase-qty" data-idx="${idx}">+</button>
        `;
        itemDiv.appendChild(controls);
        itemDiv.appendChild(renderNutritionLabel(item.profileObject, item.quantity, false));
        container.appendChild(itemDiv);
    });

    container.querySelectorAll(".decrease-qty").forEach(button => {
        button.onclick = function () {
            const idx = +button.dataset.idx;
            if (menuItems[idx].quantity > 1) {
                menuItems[idx].quantity--;
                renderMenuLabels();
            }
        };
    });
    container.querySelectorAll(".increase-qty").forEach(button => {
        button.onclick = function () {
            const idx = +button.dataset.idx;
            menuItems[idx].quantity++;
            renderMenuLabels();
        };
    });
    container.querySelectorAll(".qty-input").forEach(input => {
        input.onchange = function () {
            const idx = +input.dataset.idx;
            menuItems[idx].quantity = Math.max(1, parseInt(input.value) || 1);
            renderMenuLabels();
        };
    });

    container.querySelectorAll(".remove-item-btn").forEach(button => {
        button.onclick = function () {
            const idx = +button.dataset.idx;
            removeFromMenu(idx);
        };
    });
}

function removeFromMenu(index) {
    menuItems.splice(index, 1);
    renderMenuLabels();
}

function renderNutritionLabel(profileObject, quantity = 1, isAggregate = false) {
    const div = document.createElement("div");
    div.className = isAggregate ? "nutrition-label aggregate" : "nutrition-label";

    // Add nutrition facts header
    div.innerHTML = `
        <div class="nutrition-facts-header">
            ${isAggregate ? 'Menu Total - Nutrition Facts' : 'Nutrition Facts'}
        </div>
        <div class="item-name">${profileObject.itemName}</div>
        <hr class="thick-line">
        <div class="serving-size">Amount Per Serving</div>
        <hr class="thin-line">
    `;

    profileObject.sections.forEach(section => {
        const val = (section.value * quantity);
        const unit = getUnit(section.name);
        const formattedVal = formatValue(val, section.name);
        const dailyValue = section.dailyValue ? Math.round(section.dailyValue * quantity) : null;

        const sectionDiv = document.createElement("div");
        sectionDiv.className = "nutrition-section";
        sectionDiv.innerHTML = `
            <div class="section-title">
                <span><strong>${section.name}</strong> <span class="value">${formattedVal}${unit}</span></span>
                <span class="daily-value">${dailyValue ? dailyValue + '%' : ''}</span>
            </div>
        `;

        if (section.subsections) {
            section.subsections.forEach(subsection => {
                const subVal = (subsection.value * quantity);
                const subUnit = getUnit(subsection.name);
                const subFormattedVal = formatValue(subVal, subsection.name);
                const subDailyValue = subsection.dailyValue ? Math.round(subsection.dailyValue * quantity) : null;

                const subSectionDiv = document.createElement("div");
                subSectionDiv.className = "sub-section";
                subSectionDiv.innerHTML = `
                    <span>${subsection.name}</span>
                    <span class="value">${subFormattedVal}${subUnit}</span>
                    <span class="daily-value">${subDailyValue ? subDailyValue + '%' : ''}</span>
                `;
                sectionDiv.appendChild(subSectionDiv);
            });
        }

        div.appendChild(sectionDiv);
        div.appendChild(document.createElement('hr')).classList.add('thin-line');
    });

    return div;
}

function getUnit(nutrientName) {
    const name = nutrientName.toLowerCase();
    if (name.includes('calories')) return '';
    if (name.includes('sodium') || name.includes('potassium') || name.includes('calcium') || name.includes('iron') || name.includes('vitamin d') || name.includes('cholesterol')) return 'mg';
    if (name.includes('caffeine')) return 'mg';
    return 'g'; // Default for fats, carbs, protein, fiber, etc.
}

function formatValue(value, nutrientName) {
    const name = nutrientName.toLowerCase();
    if (name.includes('calories')) {
        return Math.round(value).toString();
    }
    return value.toFixed(1);
}

function updateAggregateProfile() {
    const aggSections = {};
    menuItems.forEach(item => {
        item.profileObject.sections.forEach(section => {
            if (!aggSections[section.name]) {
                aggSections[section.name] = 0;
            }
            aggSections[section.name] += section.value * item.quantity;
            if (section.subsections) {
                section.subsections.forEach(subsection => {
                    const key = section.name + " - " + subsection.name;
                    if (!aggSections[key]) {
                        aggSections[key] = 0;
                    }
                    aggSections[key] += subsection.value * item.quantity;
                });
            }
        });
    });

    const sections = [];
    Object.keys(aggSections).forEach(name => {
        if (name.includes(" - ")) {
            const [parent, sub] = name.split(" - ");
            let parentSection = sections.find(s => s.name === parent);
            if (!parentSection) {
                parentSection = { name: parent, value: 0, subsections: [] };
                sections.push(parentSection);
            }
            parentSection.subsections = parentSection.subsections || [];
            parentSection.subsections.push({ name: sub, value: aggSections[name] });
        } else {
            sections.push({ name, value: aggSections[name] });
        }
    });
    aggregateProfile = {
        itemName: "Menu Total",
        sections
    };
}

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

// Recommended daily intake / Average impacts
const dailyValueCalculations = {
    fat: 65, // Total Fat
    satFat: 20, // Saturated Fat
    cholesterol: 300, // Cholesterol
    sodium: 2400, // Sodium
    carb: 300, // Total Carbohydrate
    fiber: 25, // Dietary Fiber
    addedSugars: 50, // Added Sugars
    vitaminD: 20, // Vitamin D (mcg)
    calcium: 1300, // Calcium (mg)
    iron: 18, // Iron (mg)
    potassium: 4700 // Potassium (mg)
};
$(document).ready(function () {
    $("#dailyDiv").text(JSON.stringify(dailyValueCalculations));
});

// Calculate daily values (assuming source data is for a typical 2,000-calorie diet)
// Called from layout-nutrition.js
function calculateDailyValue(value, type) {
    const base = dailyValueCalculations[type];
    return base ? ((value / base) * 100).toFixed(0) : null;
}

function populateNutritionLabel(data) {
    document.getElementById("item-name").innerText = data.itemName;

    const sectionsContainer = document.getElementById("sections");
    sectionsContainer.innerHTML = ''; // Clear existing content

    data.sections.forEach(section => {
        const sectionDiv = document.createElement("div");
        sectionDiv.classList.add("nutrition-section");

        // Add section name and value
        sectionDiv.innerHTML = `
            <div class="section-title">
                <span><strong>${section.name}</strong> <span class="value">${section.value}${section.value ? 'g' : ''}</span></span>
                <span class="daily-value">${section.dailyValue ? section.dailyValue + '%' : ''}</span>
            </div>
        `;

        // Add subsections if they exist
        if (section.subsections) {
            section.subsections.forEach(subsection => {
                const subSectionDiv = document.createElement("div");
                subSectionDiv.classList.add("sub-section");
                if (subsection.extraIndent) subSectionDiv.classList.add("extra-indent");

                subSectionDiv.innerHTML = `
                    <span>${subsection.name}</span>
                    <span class="value">${subsection.value}${subsection.value ? 'g' : ''}</span>
                    <span class="daily-value">${subsection.dailyValue ? subsection.dailyValue + '%' : ''}</span>
                `;

                sectionDiv.appendChild(subSectionDiv);
            });
        }

        sectionsContainer.appendChild(sectionDiv);
        sectionsContainer.appendChild(document.createElement('hr')).classList.add('thin-line');
    });
}

// Function to update the nutrition label based on quantity
function updateNutritionLabel(quantity) {
    const updatedData = JSON.parse(JSON.stringify(profileObject));
    updatedData.sections.forEach(section => {
        if (section.value) section.value = (section.value * quantity).toFixed(2);
        if (section.dailyValue) section.dailyValue = (section.dailyValue * quantity).toFixed(0);
        if (section.subsections) {
            section.subsections.forEach(subsection => {
                if (subsection.value) subsection.value = (subsection.value * quantity).toFixed(2);
                if (subsection.dailyValue) subsection.dailyValue = (subsection.dailyValue * quantity).toFixed(0);
            });
        }
    });
    populateNutritionLabel(updatedData);
}

// Parse the source data into the desired structure
let profileObject = {};

function loadProfile() {
    let hash = getUrlHash();
    let labelType = "food";
    let whichLayout = "js/layout-nutrition.js";
    if (hash.layout == "product") {
        labelType = "product";
        whichLayout = "js/layout-product.js";
    } // Also add removeElement() line below for new layouts.
    whichLayout = "/profile/item/" + whichLayout;

    // Remove prior layout-.js since createProfileObject() repeats.
    // detach() could possibly be used to assign to a holder then restore.
    removeElement('/profile/item/js/layout-nutrition.js'); // Resides in localsite/js/localsite.js
    removeElement('/profile/item/js/layout-product.js');

    loadScript(whichLayout, function(results) {
        let sourceData = {};
        // TO DO: Load these from API or file
        if (labelType == "product") {
            // https://github.com/ModelEarth/io/blob/main/template/product/product-nodashes.yaml
            sourceData = {
                itemName: 'Sample Product',
                id: "ec3yznau",
                ref: "https://openepd.buildingtransparency.org/api/epds/EC3YZNAU",
                doctype: "OpenEPD",
                version: null,
                language: "en",
                valueGlobalWarmingPotential: 445 ,
                ghgunits: "kg CO2 eq"
                /*
                private: false,
                program_operator_doc_id: "9BD4F9CB-3584-4D34-90F8-B6E40B69653D",
                program_operator_version: null,
                third_party_verification_url: null,
                date_of_issue: '2019-01-28T00:00:00Z',
                valid_until: '2024-01-28T00:00:00Z',
                kg_C_per_declared_unit: null,
                product_name: DM0115CA,
                product_sku: null,
                product_description: "DOT MINOR 3/4 15FA 3-5SL AIR",
                product_image_small: null,
                product_image: null,
                product_service_life_years: null,
                applicable_in: null,
                product_usage_description: null,
                product_usage_image: null,
                manufacturing_description: null,
                manufacturing_image: null,
                compliance: []
                */
            };
        }

        if (labelType == "food") {
            // Example source data from the provided object
            sourceData = {
                showServingUnitQuantity: false,
                itemName: 'Bleu Cheese Dressing',
                ingredientList: 'Bleu Cheese Dressing',
                decimalPlacesForQuantityTextbox: 2,
                valueServingUnitQuantity: 1,
                allowFDARounding: true,
                decimalPlacesForNutrition: 2,
                showPolyFat: false,
                showMonoFat: false,
                valueCalories: 450,
                valueFatCalories: 430,
                valueTotalFat: 48,
                valueSatFat: 6,
                valueTransFat: 0,
                valueCholesterol: 30,
                valueSodium: 780,
                valueTotalCarb: 3,
                valueFibers: 0,
                valueSugars: 3,
                valueProteins: 3,
                valueVitaminD: 12.22,
                valuePotassium_2018: 4.22,
                valueCalcium: 7.22,
                valueIron: 11.22,
                valueAddedSugars: 17,
                valueCaffeine: 15.63,
                showLegacyVersion: false
            };
        }

        // TO DO: Since createProfileObject occurs twice, drop one of the layout-.js files.

        profileObject = createProfileObject(sourceData); // Guessing
        console.log("profileObject:")
        console.log(profileObject);

        $(document).ready(function () { // TO DO: Change to just wait for #item-name
            if (hash.layout == "product") {
                $("#nutritionFooter").hide();
            } else {
                $("#nutritionFooter").show();
            }

            // Event listeners for quantity input
            document.getElementById('quantity-input').addEventListener('change', (e) => {
                const quantity = parseFloat(e.target.value) || 1;
                updateNutritionLabel(quantity);
            });

            document.getElementById('decrease-quantity').addEventListener('click', () => {
                const input = document.getElementById('quantity-input');
                let quantity = parseFloat(input.value) || 1;
                if (quantity > 1) {
                    quantity--;
                    input.value = quantity;
                    updateNutritionLabel(quantity);
                }
            });

            document.getElementById('increase-quantity').addEventListener('click', () => {
                const input = document.getElementById('quantity-input');
                let quantity = parseFloat(input.value) || 1;
                quantity++;
                input.value = quantity;
                updateNutritionLabel(quantity);
            });

            // Initial population - HTML
            populateNutritionLabel(profileObject);
            
            $("#sourceDiv").text(JSON.stringify(sourceData));
            $("#jsonDiv").text(JSON.stringify(profileObject));
        });
    });
}