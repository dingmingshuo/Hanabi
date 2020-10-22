%{
    var key_in_pitch = 60;
    var key_out_pitch = 60;

    function get_pitch_from_key(key){
        switch(key) {
        case "A":
            return 57;
            break;
        case "B":
            return 59;
            break;
        case "C":
            return 60;
            break;
        case "D":
            return 62;
            break;
        case "E":
            return 64;
            break;
        case "F":
            return 65;
            break;
        case "G":
            return 67;
            break;
        }
    } 
    
    function get_pitch_from_note(note){
        switch(note) {
        case 1:
            return 0;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 4;
            break;
        case 4:
            return 5;
            break;
        case 5:
            return 7;
            break;
        case 6:
            return 9;
            break;
        case 7:
            return 11;
            break;
        }
    }
%}


%lex

%%
\s+                   /* skip whitespace */
[1-7]                 return 'PITCH';
"#"                   return '#';
"b"                   return 'b';
"|"                   return 'BAR_LINE';
":"                   return ':';
"key_in"              return 'MARK_KEY_IN';
"key_out"             return 'MARK_KEY_OUT';
"speed"               return 'MARK_SPEED';
[A-G]                 return 'KEY';
<<EOF>>               return 'EOF';

/lex

%left '#' 'b'
%start notation

%%

notation
    : description bars EOF
        {}
    ;

description
    :
        {}
    | description key_in
        {}
    | description key_out
        {}
    ;

key_in
    : MARK_KEY_IN ':' KEY
        {
            key_in_pitch = get_pitch_from_key($3);
        }
    ;

key_out
    : MARK_KEY_OUT ':' KEY
        {
            key_out_pitch = get_pitch_from_key($3);
        }
    ;

pitch
    : PITCH
        {console.log(key_in_pitch + get_pitch_from_note(Number($1)));}
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
