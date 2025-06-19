# DFC Data

FY24.xlsx downloaded manually from:

https://www.dfc.gov/sites/default/files/media/documents/FY24%20DFC%20Annual%20Project%20Data_508.xlsx


DFC Active Projects - columns:

Fiscal Year, Project Number, Project Type, Region, Country, Department, Framework, Project Name, Committed, NAICS Sector, Project Description, Project Profile URL

DFC-ActiveProjects.xlsx

Update my single page javascript app residing in an index.html page. Avoid adding any server-side node code. Don't convert into a React project or use Vite. Avoid adding external scripts such as react.development.js, react-dom.development.js, babel.min.js.

TPL IG, Redacted, COPS IG, DI

Finance, Insurance, Investment Funds, Equity Investments, Technical Assistance

NAICS
Agriculture, Accommodation and Food Services, Educational Services, Finance and Insurance, Health Care, Information, Utilities

Prompt:

Provide client-side javascript that opens this Excel file and displays a list.

Default to the "Project Data" tab.
Omit the first and second row when displaying the list.

The column titles are in the second row: Fiscal Year, Project Number, Project Type, Region, Country, Department, Framework, Project Name, Committed, NAICS Sector, Project Description, Project Profile URL, Exposure, Originating Agency, Country Income Level, Support Type, Source of Funding, Currency, Sovereign (Yes/No), Estimated Term (Years), Environmental and Social Risk Category, 2X identifier, 2X Qualifying Criteria, IQ Tier

For each listing, display text from all the columns with titles (when the field is populated). 


Prompt used to add data pull and filters to preferences page:

Update my single page javascript app which resides in an index.html page. Avoid adding any server-side node code. Don't convert into a React project or use Vite. Avoid adding external scripts such as react.development.js, react-dom.development.js, babel.min.js.

Load the list from an Excel sheet called DFC-ActiveProjects.xlsx which is located in the same folder as the existing index.html file. Retain a placeholder list and only display it if the load from Excel fails.

The first row of the Excel sheet contains the following columns names for the titles to include in the list in index.html when a row's field is not empty.
Fiscal Year, Project Number, Project Type, Region, Country, Department, Framework, Project Name, Committed, NAICS Sector, Project Description, Project Profile URL

Add pagination. Display 20 results, with the option to view 50, 100, 500, 1000, All. Omit the high numbers when the total results are fewer.

Display the total the committed column where total in the upper right.

Display the "Project Name" as the listing's title.

Retain the existing "My Preferences" checkboxes. Auto-check the other checkboxes (described below) that match the selected preferences and show the grey tags for the projects that match. Uncheck the others when unchecking the preferences. For example, the "Agriculture" preference would auto-select the "Agriculture" NAICS Sector. Get creative with these associations so there are more than less.

Add check boxes for selecting the "Department" with:
Finance, Insurance, Investment Funds, Equity Investments, Technical Assistance.

Add check boxes for selecting the "NAICS Sector" with: Agriculture, Accommodation and Food Services, Educational Services, Finance and Insurance, Health Care, Information, Utilities.

And checkboxes for choosing the "Project Type" which checkboxes of: TPL IG, Redacted, COPS IG, DI

Add a "Matches All" and "Matches Any" toggle to apply AND/OR logic for the checkboxes selected.
