\RequirePackage{dTeX-base}
\dTeX@ProvidesClass{
  name={protocoll},
  version={1.1},
  date={2019-04-28},
  description={Datateknologsektionen Chalmers}
}

\newif\iftwojust
\twojustfalse
\DeclareOption{twojust}{\twojusttrue}

\dTeX@Extend[version=1.0]{meeting}

% bundle with class
\dTeX@Dep{decisions}
% commands used
%   marginnote
\dTeX@Dep{marginnote}

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
