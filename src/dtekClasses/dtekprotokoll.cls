\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{dtekprotokoll}[2013/04/07 Datateknologsektionen Chalmers]

\newif\iftwojust
\twojustfalse
\DeclareOption{twojust}{\twojusttrue}
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{dtek}
}

\ProcessOptions\relax

\LoadClass{dtek}

% helps creating table of contents
% commands used
%   newlistof
\dTeX@RequirePackage{tocloft}

% bundle with class
\dTeX@Dep{decisions}
% commands used
%   marginnote
\dTeX@Dep{marginnote}

\DeclareDocumentCommand \motesnummer {m} {%
  \DeclareDocumentCommand \@motesnummer {}{#1}
}
\DeclareDocumentCommand \verksamhetsar {m} {%
  \DeclareDocumentCommand \@verksamhetsar {}{#1}
}
\DeclareDocumentCommand \start {m} {%
  \DeclareDocumentCommand \@start {}{#1}
}
\DeclareDocumentCommand \plats {m} {%
  \DeclareDocumentCommand \@plats {}{#1}
}

\NewDocumentCommand \funktionar {ommm} {%
  \IfNoValueTF {#1}
  {}
  {\global\expandafter\def\csname #1\endcsname{#3}}
  #2 & #3 & #4\\
}

\DeclareDocumentEnvironment {funktionarer} {} {%
  \begin{tabular}{l l l}
    \itshape Funktion & \itshape Namn & \itshape E-mail/CID\\
}{%
  \end{tabular}
}


\DeclareDocumentCommand \anm {m} {%
  \leavevmode\marginnote{Anm.}#1%
}

\DeclareDocumentCommand \maketitle {} {%
  {\centering \bf{\LARGE{\@title\ \@date}}\par}
  
  Kl: \@start\\
  Mötesnummer: \@motesnummer\ - \@verksamhetsar\\
  Plats: \@plats
}

\newlistof{bilagor}{bil}{Bilagor}

% \makebilaga{kortnamn}{Ett längre namn}{filnamn}
\DeclareDocumentCommand \makebilaga {m m m}{%
  \includepdf[ pages=-
             , addtolist={1,bilagor,#2,bil:#1}
  ]{#3}
}

% \bilaga{kortnamn} Referera till en bilaga
\DeclareDocumentCommand \bilaga {m}{%
  \hyperref[bil:#1]{bilaga \ref*{bil:#1}}%
}

\DeclareDocumentCommand \makesigns {m m o o} {%
  \parbox{\textwidth}{%
    \vspace{1cm}
    \makesign{Sekreterare #1}
    
    \makesign{Mötesordförande #2}

    \IfValueTF{#3}{%
      \makesign{Justerare #3}
    }{}

    \IfValueTF{#4}{%
      \makesign{Justerare #4}
    }{}
  }
}

\RenewDocumentCommand \makeheadfoot {}{%
  \makehf

  \cfoot{%
    \vspace{0.55cm}
    \parbox{26pt}{%
      \centering
      \rule{25pt}{0.5pt}\\
      Sekr.
    }
    \hspace{1pt}
    \parbox{26pt}{%
      \centering
      \rule{25pt}{0.5pt}\\
      Ordf.
    }
    \hspace{1pt}
    \iftwojust
      \parbox{54pt}{%
        \centering
        \rule{25pt}{0.5pt}\hspace{4pt}\rule{25pt}{0.5pt}\\
        Justerare
      }
    \else
      \parbox{26pt}{%
        \centering
        \rule{25pt}{0.5pt}\\
        Just.
      }
    \fi
  }
  \rhead{%
    Sidan \thepage\ av \pageref{LastPage}\\
    \@date \\
    Mötesnr. \@motesnummer\ - \@verksamhetsar
  }
}

\endinput
