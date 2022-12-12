%{
    #include<iostream>
    #include<stdlib.h>
    #include<string.h>
    #include<map>
    #include<sstream>

    #ifndef YYSTYPE 
    #define YYSTYPE string
    #endif

    using namespace std;
    char idStr[50];

    map<string, string>syMap;
    map<string, string>::iterator flag;
 
    int yylex();
    extern int yyparse();
    FILE* yyin;
    void yyerror(const char* s);


    string assign (string id,string value);
    string read   (string id);
    string add(string a, string b);
    string sub(string a, string b);
    string mul(string a, string b);
    string div(string a, string b);
    string neg(string a);


%}

%token NUMBER ADD SUB MUL DIV LBR RBR ID EQU

%left EQU
%left ADD SUB
%left MUL DIV
%right UMINUS


%%

lines   :   lines expr ';' {cout<<$2<<endl;}
|       lines ';'
|
;


expr    :   expr ADD expr {$$ = add($1, $3);}
|       expr SUB expr { $$ = sub($1, $3);}
|       expr MUL expr { $$ = mul($1, $3);}
|       expr DIV expr {$$ = div($1, $3); }
|       LBR expr RBR  { $$ = $2;}
|       SUB expr %prec UMINUS {$$ = neg($2);}
|       NUMBER {$$ = $1;}
|       ID { $$ = read($1);}
|       assign
;



assign  :   ID EQU expr  {$$ = assign($1,$3);}



%%

int yylex(){

    int t;

    while(1){

        t=getchar();
        if(t=='\n'||t==' '|| t=='\t'){}

        else if(isdigit(t)){
            char* numStr = new char[50];
            int ti=0;
            while(isdigit(t)){

                numStr[ti]=t;
                t=getchar();
                ti++;

            }
            numStr[ti]='\0';
            yylval=numStr;
            ungetc(t,stdin);
            return NUMBER;

        }

        else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')){

            int ti=0;
            while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')||(t>='0'&&t<='9')){

                idStr[ti]=t;
                t=getchar();
                ti++;

            }
            idStr[ti]='\0';
            yylval=idStr;
            ungetc(t,stdin);
            return ID;


        }
        
        else if(t=='+') return ADD;
        else if(t=='-') return SUB;
        else if(t=='*') return MUL;
        else if(t=='/') return DIV;
        else if(t=='(') return LBR;
        else if(t==')') return RBR; 
        else if(t=='=') return EQU;

        else return t;


    }
}

int main(void){

    yyin=stdin;
    do{

        yyparse();

    }while(!feof(yyin));
    return 0;


}


void yyerror(const char* s){

    fprintf(stderr,"PArse error: %s\n",s);
    exit(1);

}
    




//赋值
string assign (string id,string value)
{

    syMap[id] = value;
    return syMap[id];
}
//读取
string read  (string id)
{
    flag = syMap.find(id);
    if(flag != syMap.end()){
        return syMap[id];
    }
    else return "0\0";
}


//运算
string add(string a, string b)
{
    double val = stod(a)+stod(b);
    return to_string(val);
}
string sub(string a, string b)
{
    double val = stod(a)-stod(b);
    return to_string(val);
}
string mul(string a, string b)
{
    double val = stod(a)*stod(b);
    return to_string(val);
}
string div(string a, string b)
{
    double val = stod(a)/stod(b);
    return to_string(val);
}
string neg(string a)
{
    double aval = stod(a);
    double val = -aval;
    return to_string(val);
}


