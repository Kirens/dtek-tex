\usepackage{xparse}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{DTekActivityReport}[2018/08/27 v3.0 A class for creation of meeting summons for members at The Engineering Division of Computer Science at Chalmers]
\newcommand \DTekSummonsVersion {v3.0}

% Load meeting superclass
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{DTekBase}}
\ProcessOptions\relax
\LoadClass[version=v3.0]{DTekBase}
\LeastSignificantClassIs{DTekActivityReport}

% Make sure this class is the expected version
\AssertRequestedClassVersion{DTekActivityReport}{\DTekSummonsVersion}


% https://tex.stackexchange.com/questions/10426/def-taking-rest-of-the-line-as-argument
\newcommand{\newlinecommand}[2]{%
  \def#1{%
    \begingroup%
    \escapechar=`\\%
    \catcode\endlinechar=\active%
    \csname\string#1\endcsname%
  }%
  \begingroup%
  \escapechar=`\\%
  \lccode`\~=\endlinechar%
  \lowercase{%
    \expandafter\endgroup
    \expandafter\def\csname\string#1\endcsname##1~%
  }{\endgroup#2}%
}

\CreateValueDefiners
    {TheCommittee, ThePeriod, TheStudyPeriod}

\let\TheStudyPeriodSetter\TheStudyPeriodIs
\renewcommand\TheStudyPeriodIs[1]{
    \TheStudyPeriodSetter{#1}
    \ThePeriodIs{LP#1}
}

%\DeclareSimpleDocumentKind{OperationsReport}
\RequirePackage{collect}
\definecollection{Arrangemangslista}
\newcommand \InsetArrLista {\includecollection{Arrangemangslista}}



\def\NyttArr #1 \SpecialBreak #2{
    \begin{collect}{Arrangemangslista}{}{}{}{}%
        #1 & #2 \\
    \end{collect}
  }

\DeclareLineCommand \EttArr {
    \expandafter\NyttArr #1 \SpecialBreak {#2}
}
\RequirePackage{datetime2}

\def \StripZero #1#2\EndStripZero{
    \ifnum 0 = #1 #2\else #1#2\fi
}

\catcode`*=\active\relax
\DeclareDocumentEnvironment {ArrLista} {} {%
    \begingroup
    \catcode`*=\active\relax
    \def* ##1-##2-##3 - {\EttArr[\StripZero ##3\EndStripZero\space\DTMmonthname{##2}]}
}{%
    \endgroup
}
\catcode`*=12\relax

\DeclareDocumentKind {VerksamhetsRapport} {}[][%
    \MakeTitle
    \section{Arrangemangslista}
    \begin{tabular}{rl}
        \InsetArrLista
    \end{tabular}
    \section{Rapportering av verksamhet}
][%
        \end{mdframed}%
    \end{adjustwidth}%
]
\DeclareDocumentKind {Economy} {}[][%
    \MakeTitle
    \section{Rapportering av ekonomi}
][%
]

\DeclareDocumentCommand \MakeTitle {} {%
    \begin{center}
        \textbf{\LARGE Verksamhetsrapport}\\[0.5cm]
        \Large
        Kommitté: \TheCommittee\\
        Period: \ThePeriod
    \end{center}
    \bigskip
}

\RequirePackage{changepage, mdframed}

\providecommand \InVP {f}
\newlinecommand \Punkt {
    \if t\InVP%
            \end{mdframed}%
        \end{adjustwidth}%
    \fi
    
    \renewcommand \InVP {t}%
    \subsection{#1}
    \vspace{0.5em}
    \begin{adjustwidth}{2cm}{}%
        \begin{mdframed}[topline=false, rightline=false, bottomline=false, leftline=false]
        \small
}


\IgnoreSpaceInCode
\newlength{\mylength}
\DeclareDocumentCommand \StatusWord { mm } {
    \DeclareLineCommand #1 {
        \par\medbreak\noindent
        {\normalsize
            \settowidth{\mylength}{#2}
            \hspace{-\mylength}\hspace{-1em}#2
            \hspace{1em}##2
        }%
        \ifx##1\EmptyLineOptionalArg\medbreak\noindent\fi
    }
}
\AcknowledgeSpaceInCode

\StatusWord \Avslutat {Avslutat}
\StatusWord \Kasserat {Kasserat}
\StatusWord \Vilande {Vilande}
\StatusWord \IFas {I Fas}
\StatusWord \UrFas {Släpande}

%\Completed
%\Dropped
%\
%\InStepWith
%\BehindOn
%
%% Swedish commands
%\newcommand \Avslutad {}

% Strikethroughs
\RequirePackage[normalem]{ulem}
\newlinecommand \Gammal {{\normalsize\sout{#1}}\par\noindent}
\newlinecommand \Senast {{\normalsize\underline{Uppdaterad:} #1}\medbreak\noindent}

\begingroup%
\lccode`\~=\endlinechar%
\lowercase{%
    \expandafter\endgroup
    \long\def \Uppdaterad#1\Gammal {%
        #1[f]~%
        \Gammal%
    }
}
\DeclareDocumentCommand \Ny {m} {#1\underline{Ny:} }



%\RequirePackage{ltablex}
\DeclareDocumentCommand \EK { mmmmm }{
    {\subsection{#1}}
    \small
    \begin{tabularx}{\linewidth}{lrrrX}
        & \multicolumn{2}{c}{Budget} & Utfall & Kommentar \\
        & Förra & Ny \\\hline
    \endhead
        #5
    \hline
        Summa & #2 & #3 & #4 \\%
    \end{tabularx}
}
\DeclareDocumentCommand \Post { momom }{%
    #1 & #3 & \IfNoValueTF{#4}{#3}{#4} & #5 \IfNoValueF{#2}{& #2}\\%
}




\RequirePackage{collect}
\definecollection{FinalDocument}
\newcommand \InsetFinalDocument {\includecollection{FinalDocument}}

\DeclareDocumentCommand \EKStart {} {%
    \begin{collect}{FinalDocument}{}{}{}{}%
        \section*{aaa}
        \begin{tabularx}{\linewidth}{l|r|r|l}%
    \end{collect}
}
\DeclareDocumentCommand \EKCont {} {%
    \begin{collect}{FinalDocument}{}{}{}{}%
        \end{tabularx}
        \section*{bbb}
        \begin{tabularx}{\linewidth}{l|r|r|l}%
    \end{collect}
}
\DeclareDocumentCommand \EKEnd {} {%
    \begin{collect}{FinalDocument}{}{}{}{}%
        \end{tabularx}
    \end{collect}
}

\DeclareDocumentCommand \PostCont {m m m m} {%
    \begin{collect}{FinalDocument}{}{}{}{}%
        \\ #1 & #2 & #3 & #4%
    \end{collect}
}
\DeclareDocumentCommand \PostStart {m m m m} {%
    \begin{collect}{FinalDocument}{}{}{}{}%
        #1 & #2 & #3 & #4%
    \end{collect}
}
\DeclareDocumentCommand \PostStart {m m m} {%
    #1 & #2 & #3 &%
}
\DeclareDocumentCommand \PostCont {m m m} {%
    \\ #1 & #2 & #3 &%
}
\newlinecommand \TextBf
  {
    -- #1 --
  }
\newcommand{\newlinecommandI}[2]{%
  \def#1{%
    \begingroup%
    \escapechar=`\\%
    \catcode`)=\active%
    \csname\string#1\endcsname%
  }%
  \begingroup%
  \escapechar=`\\%
  \lccode`\~=`)%
  \lowercase{%
    \expandafter\endgroup
    \expandafter\def\csname\string#1\endcsname##1~%
  }{\endgroup#2}%
}
\newlinecommandI \abc
  {
    -- #1 --
  }
\DeclareLineCommand \Post
  {
    \PostHelper #2 |
  }
\providecommand \InPost {f}
\Def \PostHelper {#1 | #2 | #3 |}
  {%
    \if t\InPost%
        \PostCont{#1}{#2}{#3}{4}%
    \else%
        \PostStart{#1}{#2}{#3}{4}%
    \fi%
    \renewcommand \InPost {t}%
  }

%    \EK 22 / 20 | 4.63 | Utgifter
%        \Post 3.4 / 5 | 0 / 3.2 | Representationskläder


\DocumentTitleIs{Rapport \TheCommittee~\ThePeriod}
\DocumentNameIs{\DocumentTitle}

