\RequirePackage{dTeX-base}
\dTeX@ProvidesClass{
  name={summon},
  version={1.1},
  date={2019-05-01},
  description={Datateknologsektionen Chalmers}
}

\dTeX@Extend[version=1.0]{meeting}

% bundle with class
\dTeX@Dep{agenda}

% Use value definers to specify details about the document
\dTeX@Dep{valueDefiner}

% Enable adding pre- and postambles.
\dTeX@Dep{documentWrapper}
\SetDocumentWrapper{summon}{}

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
\RenewDocumentCommand \maketitle {} {%
  {\bf \LARGE \@title} \\[0.5cm]

  \begin{tabular} {l l l}
    Tid \& datum: & \TheStartTime
      & \TheWeekDay\ \TheYear-\TheMonth-\TheDay \\
    Mötesnummer: & \TheMeetingNumber\ & \TheFiscalYear \\
    Plats: & \multicolumn{2}{l}{\TheLocation} \\
  \end{tabular}
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
\NewDocumentCommand \elab {m} {%
  \ifthenelse{ \equal{\elaboration}{true} }{%
    \\ {\it #1}
  }{% Gör ingenting om inte \elaboration är sant
  }
}

% Fixa så secretkommandot genererar en text som bara syns
% i agendor, i.e när secret = true
\NewDocumentCommand \secr {m} {%
  \ifthenelse{ \equal{\secret}{true}}{%
    \\ {\tt #1}
  }{% Gör ingenting om inte \secret är sant
  }
}
