## Code Documentation 

### dartdoc produces static files with a predictable link structure.

index.html                           # homepage

index.json                          # machine-readable index

library-name/                       # : is turned into a - e.g. dart:core => dart-core

  ClassName-class.html              # "homepage" for a class (and enum)
  
  ClassName/
  
    ClassName.html                  # constructor
    
    ClassName.namedConstructor.html # named constructor
    
    method.html
    
    property.html
  
  CONSTANT.html
  
  property.html
  
  top-level-function.html
