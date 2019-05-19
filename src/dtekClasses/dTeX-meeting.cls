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


% Deklarera mötets nummer i ordningen sen föreningen tillsattes
\DeclareDocumentCommand \motesnummer {m} {
  \DeclareDocumentCommand \@motesnummer {}{#1}
}

% Deklarera föreningens verksamhetsår
\DeclareDocumentCommand \verksamhetsar {m} {
  \DeclareDocumentCommand \@verksamhetsar {}{#1}
}

% Deklarera mötets start
\DeclareDocumentCommand \start {m} {
  \DeclareDocumentCommand \@start {}{#1}
}

% Deklarera mötets plats
\DeclareDocumentCommand \plats {m} {
  \DeclareDocumentCommand \@plats {}{#1}
}

