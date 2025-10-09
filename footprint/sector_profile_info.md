# About Sector Profile Report

Updates to the [prior sector profile](sector_profile_prior.html) include two tables: the technical coefficient matrix and data sources display.

### 1. Enhanced Matrix Data Filtering and Display

**Change**: Improved coefficient filtering threshold
```javascript
// Before
.filter(item => Math.abs(item.coefficient) > 0.001)

// After  
.filter(item => Math.abs(item.coefficient) > 0.0001)
```

**Rationale**: The original threshold of 0.001 was too restrictive and filtered out many meaningful economic relationships. Lowering to 0.0001 captures more inter-industry dependencies while still excluding negligible values.

**Change**: Increased number of displayed contributors
```javascript
// Before
.slice(0, 20); // Show top 20 contributors

// After
.slice(0, 25); // Show top 25 contributors
```

**Rationale**: Displaying 25 instead of 20 contributors provides a more comprehensive view of sector interdependencies without overwhelming the user interface.

### 2. Added Technical Coefficient Matrix Section

**Purpose**: Display the A matrix (technical coefficient matrix) data that shows inter-industry economic relationships.

**Implementation**: 
- New HTML section `#matrixSection` with dedicated table display
- `loadMatrixData()` function to fetch and process matrix data
- Scientific notation formatting for precise coefficient values
- Direct links to source data files on GitHub

**Benefits**:
- Transparency: Users can see the underlying economic relationships
- Validation: Direct access to source data enables verification
- Education: Helps users understand input-output economics

### 3. Added Comprehensive Data Sources Section

**Purpose**: Document all datasets used in the environmental profile analysis.

**Implementation**:
- New HTML section `#dataSourcesSection` with tabular display
- `loadDataSources()` function listing all matrices (A, B, L, D)
- Dynamic URLs based on current model (national vs state-specific)
- Usage explanations for each dataset

**Datasets Documented**:
- **A Matrix**: Technical coefficients (inter-industry relationships)
- **B Matrix**: Direct environmental coefficients 
- **L Matrix**: Leontief inverse (total requirements)
- **D Matrix**: Environmental multipliers (total impacts)
- **Sectors**: Industry classification data
- **Indicators**: Environmental impact categories
- **Demands**: Economic demand scenarios
- **Metadata**: Model version and specifications

**Benefits**:
- **Reproducibility**: Clear documentation of data sources
- **Credibility**: Links to authoritative government datasets
- **Methodology**: Explains how each dataset contributes to results
- **Accessibility**: Direct access to underlying data files

### 4. Improved Error Handling and User Experience

**Change**: Enhanced error messaging and fallback methods

- Added try-catch blocks with specific error reporting
- Alternative data access methods when primary fails
- Graceful degradation with informative messages

**Rationale**: Robust error handling ensures the report remains functional even when some data sources are unavailable, providing clear feedback to users about any issues.

### 5. Dynamic Model Detection and URL Generation

**Implementation**: 
- Integration with `getModelFolderName()` to detect current model
- Dynamic generation of GitHub URLs for data sources
- Support for both national and state-specific models

**Benefits**:
- **Accuracy**: URLs always point to correct model version
- **Flexibility**: Works with different USEEIO model variants
- **Maintenance**: Reduces need for manual URL updates

## Technical Improvements

### Scientific Notation Formatting
Implemented proper formatting for very small coefficient values using exponential notation, improving readability of technical data.

### Responsive Table Design
Both new sections use Tabulator.js with:
- Fixed heights (400px) to prevent page bloat
- Sortable columns for user exploration
- Responsive column widths
- Proper data type handling

### Integration with Existing Architecture
- Seamless integration with existing USEEIO API calls
- Consistent styling with existing report design
- No conflicts with existing functionality
- Proper async/await patterns for data loading

## Impact on User Experience

### For Technical Users
- **Enhanced Analysis**: Access to underlying mathematical relationships
- **Data Validation**: Ability to verify results against source data
- **Methodology Understanding**: Clear view of analytical approach

### For Policy Makers
- **Transparency**: Full documentation of data sources and methods
- **Credibility**: Links to authoritative government datasets
- **Decision Support**: Better understanding of sectoral interdependencies

### For Researchers
- **Reproducibility**: Complete documentation enables result replication
- **Extension**: Clear data sources facilitate additional analysis
- **Citation**: Proper attribution of data sources for academic use

## Conclusion

These enhancements transform the sector profile report from a simple results display into a comprehensive analytical tool that provides transparency, educational value, and research-grade documentation. The changes maintain the existing functionality while significantly expanding the analytical depth and credibility of the environmental impact assessment.