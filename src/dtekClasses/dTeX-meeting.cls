\RequirePackage{dTeX-base}
\dTeX@ProvidesClass{
  name={meeting},
  version={1.0},
  date={2019-05-01},
  description={Datateknologsektionen Chalmers}
}

\dTeX@Extend[version=1.1]{base}

% bundle with class
\dTeX@Dep{annex}

% Use value definers to specify details about the document
\dTeX@Dep{valueDefiner}

\title{Möte \TheDocumentName}

\fancypagestyle{DTek-meeting}{%
  \pagestyle{DTek}
  \rhead{%
    Sidan \thepage\ av \pageref{LastPage}\\
    \TheDate \\
    Mötesnr. \TheMeetingNumber\ - \TheFiscalYear
  }
}

% Deklarera mötets nummer i ordningen sen föreningen tillsattes
\dTeX@CreateValueDefiners{
  \TheMeetingNumber,
  \TheFiscalYear,
  \TheStartTime,
  \TheLocation
}
