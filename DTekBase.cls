%% DTekBase.cls
%% Copyright 2018 Datateknologsektionen Chalmers Studentkår
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainer of this work is Erik Nygren.
%
% This work consists of the files DTekBase.cls
%% End of copyright notice
%%%%
% This class file is meant to contain common components of documents 
% styled for The Engineering Division of Computer Science at Chalmers.
% As such it mainly defines base-layout such as headers and footers
% that may be overridden by derived classes. It also provides commands
% that are to use for most or all derived classes.
%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{DTekBase}[2018/08/27 v3.0 A super class for document classes for The Engineering Division of Computer Science at Chalmers]
\RequirePackage[utf8]{inputenc}
\newcommand \DTekBaseVersion {v3.0}

%%%%%%%%%%                                 %%%%%%%%%%
%%%%%%% UNCONDITIONAL CLASS PROVIDED PACKAGES %%%%%%%
%%%%%%%%%%                                 %%%%%%%%%%

% Let's us use some LaTeX3 syntax
\RequirePackage{expl3}
% Provides better command definition macros
\RequirePackage{xparse}
% Parse class options as key value data
\RequirePackage{kvoptions}
% String comparisons amongst other things
\RequirePackage{pdftexcmds}
% Header and Footer
\RequirePackage{fancyhdr}
% For including images
\RequirePackage{graphicx}
% Can determine height of header
\RequirePackage{calc}

%%%%%%%%%%                   %%%%%%%%%%
%%%%%%% CLASS PROVIDED COMMANDS %%%%%%%
%%%%%%%%%%                   %%%%%%%%%%

%%%
% Expand text to a token
% @arg m Token name
% @returns \'Token name'
%%%
\newcommand \Get [1]
    {\csname#1\endcsname}

%%%
% Expand text to a token and set its value. The token must be new
% @arg m Token name
% @arg m Token value
%%%
\newcommand \Define [2]
    {\expandafter\newcommand\csname#1\endcsname{#2}}
%%%
% Expand text to a token and redefine its value. The token must be existing
% @arg m Token name
% @arg m 
%%%
\newcommand \Redefine [2]
    {\expandafter\renewcommand\csname#1\endcsname{#2}}


\DeclareDocumentCommand \CreateValueDefinerB {m} {
    \Define{#1}{\DTekError{Undefined}{Value of #1 was never defined}{Use command #1Is{value} to define a value}}
    \expandafter\DeclareDocumentCommand\expandafter{\csname#1Is\endcsname} {m} {
        %\Redefine{#1}{##1} \ClassError{test}{#1 ##1}{}
        \global\expandafter\def\csname#1\endcsname{##1}
    }
}
\DeclareDocumentCommand \IfMacroTF {m} {
    \if\noexpand\anykindofcmd\noexpand#1%
        \expandafter\@firstoftwo%
    \else%
        \expandafter\@secondoftwo%
    \fi%
}
\newcommand\EatFirstToken[1]{}
\DeclareDocumentCommand \CreateValueDefiner {mo} {
    \IfMacroTF{#1}{
        \edef\name{\string#1}
        \edef\names{\expandafter\EatFirstToken\name}
    }{
        \edef\names{#1}
    }
    \IfNoValueTF{#2}{
        \expandafter\expandafter\expandafter\def\expandafter\csname\names\endcsname{%
            \ClassError{Undefined}{Value of \name \space was never defined}{Use command \name Is{value} to define a value}%
        }
    }{
        \expandafter\expandafter\expandafter\def\expandafter\csname\names\endcsname{#2}
    }
    
    \expandafter\expandafter\expandafter\def\expandafter\csname\names Is\endcsname##1{
        \global\expandafter\expandafter\expandafter\def\expandafter\csname\names\endcsname{##1} %TODO \long?
    }
}

\DeclareDocumentCommand \Def {mmm} {
    \IfMacroTF{#1}{
        \edef\name{\string#1}
        \edef\names{\expandafter\EatFirstToken\name}
    }{
        \edef\names{#1}
    }
    \expandafter\expandafter\expandafter\def\expandafter\csname\names\endcsname#2{#3}
}

\ExplSyntaxOn
\DeclareDocumentCommand \CreateValueDefiners {m} {
    \clist_set:Nx \l_tmpa_clist { #1 }
    \clist_map_inline:Nn \l_tmpa_clist { \CreateValueDefinerB { ##1 } }
}
\ExplSyntaxOff

%%%
% Find class option `version=` and compare it against a predefined value
% Throws a class error if there is a missmatch
% @arg m Class name
% @arg m Version value
%%%
\DeclareDocumentCommand \AssertRequestedClassVersion {mm} {
    \DeclareStringOption{version}
    \ProcessKeyvalOptions*
    
    \ifnum\pdf@strcmp{\Get{#1@version}}{#2}=0 %
    \else
        \ClassError
            {Dependency Version}
            {#1 \Get{#1@version} was requested, but this is #2}
            {Either try updating your class library or adjust the document to fit this version.}
        \stop
    \fi
}

%%
% Switch statement
%%
\DeclareDocumentCommand \CaseMacroFrom {mmm}{%
    \ifnum\pdf@strcmp{#1}{#2}=0%
        \let\TheDefault\DefaultLocked #3%
    \fi%
}
\DeclareDocumentCommand \Default {m}{%
    \ifx\TheDefault\DefaultLocked%
    \else%
        \renewcommand \TheDefault {#1}%
    \fi%
}
\newcommand \DefaultLocked {<<DEFAULT LOCKED>>}
\providecommand \Case {}
\providecommand \TheDefault {}
\newenvironment{switch}[1]{%
    \renewcommand \Case {\CaseMacroFrom{#1}}%
    \renewcommand \TheDefault {}%
}{\ifx\TheDefault\DefaultLocked\else\TheDefault\fi}


% Modified solution from Martin Scharrer and Bruno Le Floch on TeX-SE https://tex.stackexchange.com/a/10454
\newcommand \EmptyLineOptionalArg {}
\DeclareDocumentCommand \IfEmptyLineOptionalArgTF {m}{%
    \ifx\EmptyLineOptionalArg#1 \expandafter\@firstoftwo\else \expandafter\@secondoftwo\fi%
}

\DeclareDocumentCommand \IgnoreSpaceInCode { } {
    \endlinechar = 32\relax
    \catcode 9   = 9\relax
    \catcode 32  = 9\relax
}
\DeclareDocumentCommand \AcknowledgeSpaceInCode { } {
    \endlinechar = 13\relax
    \catcode 9   = 10\relax
    \catcode 32  = 10\relax
}

\IgnoreSpaceInCode
\DeclareDocumentCommand \DeclareLineCommand {m+m}{%
    \DeclareDocumentCommand{#1} {om} {
        \let\optionalopt\EmptyLineOptionalArg
        \IfNoValueF{##1}{\renewcommand\optionalopt{##1}}
        \begingroup
        \escapechar=`\\
        \catcode\endlinechar=\active
        \csname\string#1\endcsname
        {\optionalopt}##2
    }
    \begingroup
    \escapechar=`\\
    \lccode`\~=\endlinechar
    \lowercase{
        \expandafter\endgroup
        \expandafter\def
        \csname\string#1\endcsname##1##2~
    }{\endgroup#2}
}
\AcknowledgeSpaceInCode

\DeclareDocumentCommand \UpperFirst {m} {\MakeUppercase #1}
\DeclareDocumentCommand \LowerFirst {m} {\MakeLowercase #1}

\NewDocumentCommand \DTekError { mmm } {
    \ClassError
        {\LeastSignificantClass}
        {#1\MessageBreak#2}
        {#3}
}
\NewDocumentCommand \DTekFatalError { mmm } {
    \ClassError
        {\LeastSignificantClass\space Fatal}
        {#1\MessageBreak#2}
        {#3}
    \stop
}
\NewDocumentCommand \IFDTekErrorTF {m}
  {%
    %TODO
    \@
  }

%%%%%%%%%%                   %%%%%%%%%%
%%%%%%% CLASS TESTS AND CHECKS %%%%%%%
%%%%%%%%%%                   %%%%%%%%%%

\CreateValueDefiners
    {DocumentLanguage, DocumentLanguageIdentifier, LeastSignificantClass, DocumentTitle, DocumentName, DocumentSubject, DocumentAuthor, DocumentKindName}
\DocumentSubjectIs{}
\LeastSignificantClassIs{DTekBase}

% Make sure this class is the expected version
\AssertRequestedClassVersion{DTekBase}{\DTekBaseVersion}

%% Parse options
\DeclareStringOption{lang}
\DeclareStringOption[article]{baseClass}
\ProcessKeyvalOptions*

\CreateValueDefiner \BaseClassOptions[]
\begin{switch}{\DTekBase@baseClass}
    \Case{article}{
        % Base this class on the article class
        %\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
        %\ProcessOptions\relax
        \BaseClassOptionsIs{11pt, a4paper}
    }
    \Case{beamer}{
        % Base this class on the article class
        %\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
        %\ProcessOptions\relax
    }
    \Default{
        \DTekFatalError
            {Unsuported Base Class}
            {The class "\DTekBase@baseClass" is not a supported by DTek documents}
            {You've declared an option in your documentclass call that causes this error}
    }
\end{switch}
\LoadClass[\BaseClassOptions]{\DTekBase@baseClass}


% Links and pdf metadata, sets \maketitle, hence must be after article is loaded
\RequirePackage{hyperref}
% Alter page margins
\RequirePackage{geometry}



\newcommand \LangSV {swedish}
\newcommand \LangIdentifierSV {sv-SE} % RFC3066
\newcommand \LangEN {english}
\newcommand \LangIdentifierEN {en-US}
\newcommand \LangIdentifierENGB {en-GB}

\begin{switch}{\DTekBase@lang}
    \Case{sv}{
        \DocumentLanguageIs\LangSV
        \DocumentLanguageIdentifierIs\LangIdentifierSV
    }
    \Case{en}{
        \DocumentLanguageIs\LangEN
        \DocumentLanguageIdentifierIs\LangIdentifierEN
    }
    \Case{en-GB}{
        \DocumentLanguageIs\LangEN
        \DocumentLanguageIdentifierIs\LangIdentifierENGB
    }
    \Default{
        \DTekFatalError
            {Unsuported Language}
            {Language "\DTekBase@lang" is not a supported document language}
            {Use documentclass[lang=sv] or similar when importing}
    }
\end{switch}
\RequirePackage[\DocumentLanguage]{babel}%
% Day of Week
\RequirePackage[useregional,calc]{datetime2}

\DeclareDocumentCommand \WeekDay {m} {%
    \begingroup%
        \DTMsavedate{tmpDate}{#1}%
        \edef\tmpDay{\DTMweekdayname{\DTMfetchdow{tmpDate}}}%
        \tmpDay%
    \endgroup%
}
\DeclareDocumentCommand \WeekDayShort {m} {%
    \begingroup%
        \DTMsavedate{tmpDate}{#1}%
        \edef\tmpDay{\DTMshortweekdayname{\DTMfetchdow{tmpDate}}}%
        \tmpDay%
    \endgroup%
}

%%
% \StoreCounter
% Define a counter to track and store to main aux when first document pass is done
% @arg m Counter to trac
% @arg m Command to store count in
\DeclareDocumentCommand \StoreCountIn {mm} {%
    \newcounter{NumberOf#2}%
    \providecommand#1{}%
    \AtEndDocument{%
        \addtocounter{NumberOf#2}{\value{#2}}%
        \immediate\write\@mainaux{%
            \string\gdef\string#1{\number\value{NumberOf#2}}%
        }%
    }%
}



\DeclareDocumentCommand \SetupHyperref {} {%
    \hypersetup{
        pdftitle = {\DocumentName},
        pdfsubject = {\DocumentSubject},
        pdfauthor = {\DocumentAuthor},
        pdflang = {\DocumentLanguageIdentifier},
        %pdfkeywords = {\DocumentKeywords},
        pdfcreator = {DTek TeX with \LeastSignificantClass},
        pdfdisplaydoctitle,
        citecolor=black,
        filecolor=black,
        linkcolor=black,
        urlcolor=black,
        unicode
    }%
}

\RequirePackage{dtek-lang-interface}
\RequirePackage{dtek-lang-locale-\DocumentLanguage}
%\RequirePackage{dtek-lang-locale-\DocumentLanguageIdentifier}
\RequirePackage{dtek-constants}

\fancypagestyle{DTekBasicStyle}{%
    \fancyhf{}
  
    \providecommand{\headleft}{%
        \raisebox{-3mm}{\includegraphics[width=16mm]{dteklogo}}\hspace{1mm}
        \parbox[b]{10cm}{%
          \textbf{\LocaleDTek}\\
          \LocaleChs\\
          \DocumentTitle
        }
    }
    \providecommand{\headright}{%
        \LocalePage\ \thepage\ \LocaleOutOf\ \pageref{LastPage}%
    }
      
    % Calculate header height
    \settototalheight\headheight{\headleft}
    \addtolength\headheight{1.0pt}
    
    \lhead{\headleft}
    \rhead{\headright}
      
    \renewcommand{\headrule}{
        \nointerlineskip
        \hskip 16mm\hrulefill
    }
    
    \renewcommand{\footrulewidth}{\headrulewidth}
    \lfoot{\LocaleDTek\\\DivisionAddress}
    
    \rfoot{%
        \href{mailto:\DivisionEmail}{\DivisionEmail}\\
        \href{\DivisionHref}{\DivisionUrl}
    }
}



\let\SpoofedDocument\document
\let\SpoofedDocumentEnding\enddocument
\DocumentKindNameIs{Missing Document Wrapper}
\def\document{
    \DTekFatalError
        {Document Begining}
        {DTek documents have specific document environments}
        {Use "\protect\begin{\DocumentKindName}" in your case, see documentation for details}
}
% @arg m name
% @arg m args
% @arg +m preamble
% @arg +m begin
% @arg +m end
% @arg +m postamble
\DeclareDocumentCommand \DeclareDocumentKind {mm+o+o+o+o} {
    \DocumentKindNameIs{#1}
    \DeclareDocumentEnvironment {#1} {#2} {%
        % Preamble
        \SetupHyperref%
        \pagestyle{DTekBasicStyle}%
        \IfNoValueF{#3}{#3}%
        % Spoofed document insertion
        \begingroup\SpoofedDocument\def\@currenvir{#1}%
        % After Begin Document
        \IfNoValueF{#4}{#4}%
    }{%
        % Before End Document
        \IfNoValueF{#5}{#5}%
        % Spoof closing document
        \label{LastPage}
        \def\@currenvir{document}\SpoofedDocumentEnding%
        % Postamble
        \IfNoValueF{#6}{#6}%
    }
}
\DeclareDocumentCommand \DeclareSimpleDocumentKind {m} {\DeclareDocumentKind{#1}{}\relax}

