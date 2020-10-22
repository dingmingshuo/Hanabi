%lex

%%
\s+                   /* skip whitespace */
[1-7]                 return 'PITCH';
"#"                   return '#';
"b"                   return 'b';
"|"                   return 'BAR_LINE';
<<EOF>>               return 'EOF';

/lex

%left '#' 'b'
%start notation

%%

notation
    : bars EOF
        {}
    ;

pitch
    : PITCH
        {console.log("PITCH " + yytext);}
    | '#' PITCH
        {console.log("PITCH # " + yytext);}
    | '#' '#' PITCH
        {console.log("PITCH ## " + yytext);}
    | 'b' PITCH
        {console.log("PITCH b " + yytext);}
    | 'b' 'b' PITCH
        {console.log("PITCH bb " + yytext);}
    ;

note
    : pitch
        {}
    ;

notes
    : note
        {}
    | notes note
        {}
    ;


bar_line
    : BAR_LINE
        {console.log("BAR_LINE " + yytext);}
    ;

bar
    : notes bar_line
        {}
    ;

bars
    : bar
        {}
    | bars bar
        {}
    ;
