\RequirePackage{dTeX-base}
\dTeX@ProvidesClass{
  name={summon},
  version={1.1},
  date={2019-05-01},
  description={Datateknologsektionen Chalmers}
}

\dTeX@Extend[version=1.0]{meeting}

% Use value definers to specify details about the document
\dTeX@Dep{valueDefiner}

% Enable adding pre- and postambles.
\dTeX@Dep{documentWrapper}
\SetDocumentWrapper{summon}{}

\RequirePackage{datetime}
\RequirePackage{ifthen}

\topmargin -20.0pt
\headheight 56.0pt

\dTeX@CreateValueDefiners{
  \TheListKind=Föredragninsglista
}

% This is a hack since the old titles used second level expansion for the.
% That means the pdftitle set by hypersetup is missing the DocumentName.
% TODO: replace all occurances of @dokumenttyp with TheDocumentName and remove
%       this definition.
\def \@dokumenttyp {\def\x{\TheDocumentName}\x}

% Deklarera titelskapande kommandot maketitle
% Kräver att kommandon över har fått värden
\DeclareDocumentCommand \maketitle {} {%
  {\bf \LARGE \@title} \\[0.5cm]

  \begin{tabular} {l l l}
    Tid \& datum: & \TheStartTime{} & \datummote \\
    Mötesnummer: & \TheMeetingNumber\ & \TheFiscalYear \\
    Plats: & \multicolumn{2}{l}{\TheLocation} \\
  \end{tabular}
}

% Deklarerar föredragningslista som ett environment
\DeclareDocumentEnvironment {foredragningslista} {} {%
  \subsection*{\TheListKind}
  \begin{list}{\textbf{\arabic{enumi}.}}
    {\usecounter{enumi}
    \setlength{\leftmargin}{3.5\bigskipamount}
    \setlength{\itemsep}{0pt}}
}{%
  \end{list}
}

% Deklarerar underpunkter som ett environment i list
\DeclareDocumentEnvironment {underpunkter} {} {%
  \begin{list}
    {\arabic{enumi}.\arabic{enumii}}{
      \usecounter{enumii}
      \setlength{\leftmargin}{1.8\bigskipamount}}
}{%
  \end{list}
}

% Deklarerar kommandot punkt som en vettig grej i ett list environment
\DeclareDocumentCommand \punkt {m}{%
\item \textbf{#1}
}

% Bestäm mötestyp baserat på inputparameter
% (saxat från Johan Sjöbloms gamla kallelsemall)
% Om inget kommando anges från typsättaren så genereras automatiskt
% en dagordning.
\providecommand\agenda{false}
\providecommand\kallelse{false}
\providecommand\dagordning{true}

% Vilka fält som ska synas när 'agenda' genereras
% Både secret och elaboration syns.
\ifthenelse{\equal{\agenda}{true}} {
 \providecommand\elaboration{true}
 \providecommand\secret{true}
 \title{Agenda \@dokumenttyp}
}{
% Vilka fält som ska synas när 'kallelse' genereras
% Elaboration syns, men secret syns inte.
\ifthenelse{\equal{\kallelse}{true}}{
 \providecommand\elaboration{true}
 \providecommand\secret{false}
 \title{Kallelse \@dokumenttyp}
 \TheListKindIs{Preliminär föredragningslista}
}{
% Vilka fält som ska synas när 'dagordning' genereras
% Varken secret eller elaboration syns.
 \providecommand\elaboration{false}
 \providecommand\secret{false}
 \title{Dagordning \@dokumenttyp}
}}

% Fixa så elaborationkommandot genererar en text som syns
% i kallelser och agendor, i.e när elaboration = true
\DeclareDocumentCommand \elab {m} {%
  \ifthenelse{ \equal{\elaboration}{true} }{%
    \\ {\it #1}
  }{% Gör ingenting om inte \elaboration är sant
  }
}

% Fixa så secretkommandot genererar en text som bara syns
% i agendor, i.e när secret = true
\DeclareDocumentCommand \secr {m} {%
  \ifthenelse{ \equal{\secret}{true}}{%
    \\ {\tt #1}
  }{% Gör ingenting om inte \secret är sant
  }
}

% \datumiso skriver ut dagens datum på formen yyyy-mm-dd. Detta läggs
% i headern på dokumentet och behöver aldrig pillas med.
\NewDocumentCommand \dateseparate {} {-}
\RenewDocumentCommand \dateseparator {} {-}

% Skriver ut dagens datum på formen yyyy-mm-dd
\NewDocumentCommand \datumiso {} {%
  \yyyymmdddate\today
}

% Fixar fram rätt långa namn för veckodagen
\ProvideDocumentCommand \dayofweeknameidswedish {m} {%
\ifcase#1\relax
\or Söndag%
\or Måndag%
\or Tisdag%
\or Onsdag%
\or Torsdag%
\or Fredag%
\or Lördag%
\fi}

% Fixar fram rätt kortnamn för veckodagen
\ProvideDocumentCommand \shortdaysofweeknameidswedish {m} {%
\ifcase#1\relax
\or Sön%
\or Mån%
\or Tis%
\or Ons%
\or Tor%
\or Fre%
\or Lör%
\fi}

% Skapar ett fancy datum på formen YYYY-MM-DD
\DeclareDocumentCommand \datummote {} {%
  \dayofweekname{\da}{\mo}{\ye} \ye-\mo-\da
}

% Skapar ett fancy datum på formen YYYY-MM-DD av tre argument
\DeclareDocumentCommand \somedate {mmm} {%
  \dayofweekname{#3}{#2}{#1} {#1}-{#2}-{#3}
}

% Sätter datumformatet
\newdateformat{daydate}{
  \dayofweekname {\THEDAY}{\THEMONTH}{\THEYEAR}
  \THEYEAR-\twodigit{\THEMONTH}-\twodigit{\THEDAY}
}


\endinput
