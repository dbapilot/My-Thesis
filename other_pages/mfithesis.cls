\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{isethesis}[2021/04/06 v0.2 Thesis, Chair MfI]

% % % % % % % % % % % %----- % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% % variables % % % % % % % % % % % % % % % % % % % % % % % %
\newif\if@thesis@english\@thesis@englishtrue
\newif\if@thesis@master\@thesis@masterfalse
\newif\if@thesis@usebibtex\@thesis@usebibtextrue	% true by default, set to false by "biber" option
\newif\if@thesis@usenatbib\@thesis@usenatbibtrue	% true by default, set to false by "biblatex" option
%
% % options % % % % % % % % % % % % % % % % % % % % % % % % %
%% use kvoptions package
\RequirePackage{kvoptions}
\SetupKeyvalOptions{prefix=@thesis@}
%
% % declare options % % % % % % % % % % % % % % % % % % % % %
%% basic options
\DeclareStringOption[bachelor]{degree}% type of degree ("bachelor" or "master")
\DeclareStringOption[en]{language}% language of the thesis ("en" or "de")
%% bib options
\DeclareVoidOption{bibtex}{ % use bibtex as bibliography backend
	\@thesis@usebibtextrue
}
\DeclareVoidOption{biber}{ % use biber as bibliography backend (default)
	\@thesis@usebibtexfalse
}
\DeclareVoidOption{natbib}{ % use natbib as bibliography package
	\@thesis@usenatbibtrue
}
\DeclareVoidOption{biblatex}{ % use biblatex as bibliography package (default)
	\@thesis@usenatbibfalse
}
\DeclareStringOption[nyt]{sorting}		% custom sorting scheme
\DeclareStringOption[7]{maxcitenames}	% maximum number of names to show in citations
\DeclareStringOption[7]{maxbibnames}	% maximum number of names to show in bibliography entries
\DeclareStringOption[true]{firstinits}	% show only initials of authors
%
%% pass all other options to parent class
\DeclareDefaultOption{%
	\PassOptionsToClass{\CurrentOption}{scrartcl}
}
%
%% finish option processing
\ProcessKeyvalOptions*	% process keyvalue options
%
%
% % parent class and package dependencies % % % % % % % % % %
%% use "article" as parent class
\LoadClass[12pt,a4paper]{scrartcl}
%
%% load required packages
\RequirePackage{ifthen}
\RequirePackage[export]{adjustbox} % loads graphicx package as well
%
%
%% check language
\ifthenelse{\equal{\@thesis@language}{de}}{
	\@thesis@englishfalse
}
{%else
	\ifthenelse{\equal{\@thesis@language}{en}}{
		\@thesis@englishtrue
	}{%else
		\PackageError{\unexpanded{ise_thesis}}{\unexpanded{unknown language option}}
	}
}
%% check degree
\ifthenelse{\equal{\@thesis@degree}{bachelor}}{
	\@thesis@masterfalse
}{%else
	\ifthenelse{\equal{\@thesis@degree}{master}}{
		\@thesis@mastertrue
	}{%else
		\PackageError{\unexpanded{ise_thesis}}{\unexpanded{unknown degree option}}
		
	}
}
%
%
%% load babel package
\if@thesis@english
	\RequirePackage[english]{babel}
\else
	\RequirePackage[ngerman]{babel}
\fi
%
% % auxiliary commands % % % % % % % % % % % % % % % % % % %
\newcommand{\@thesis@switch}[4]{% usage: {bachEng}{bachGer}{MasEng}{MasGer}
	\if@thesis@master%
		\if@thesis@english%
			#3%
		\else%
			#4%
		\fi%
	\else%
		\if@thesis@english%
			#1%
		\else%
			#2%
		\fi%
	\fi%
}
\newcommand{\@thesis@switchlanguage}[2]{% usage: {eng}{ger}
	\if@thesis@english%
		#1%
	\else%
		#2%
	\fi%
}
\newcommand{\@thesis@switchdegree}[2]{% usage: {bachelor}{master}
	\if@thesis@master%
		#2%
	\else%
		#1%
	\fi%
}
% % title page % % % % % % % % % % % % % % % % % % % % % % %
% internal parameters
\providecommand{\@thesis@matriculationnumber}{}
\providecommand{\@thesis@advisor}{}
\providecommand{\@thesis@coadvisor}{}
\providecommand{\@thesis@externaladvisor}{}
\providecommand{\@thesis@logo}{logoUDE.pdf}
\providecommand{\@thesis@additionallogo}{}
\providecommand{\@thesis@additionallogoheight}{4.2em}
% "-in" gender suffixes for advisors
\providecommand{\@thesis@advisorsuffix}{in}
\providecommand{\@thesis@coadvisorsuffix}{in}
\providecommand{\@thesis@firstexternaladvisorsuffix}{in}
\providecommand{\@thesis@secondexternaladvisorsuffix}{}
\providecommand{\@thesis@course}{}
%
%
\newcommand{\matrno}[1]{\renewcommand{\@thesis@matriculationnumber}{#1}}
\newcommand{\matrnr}[1]{\renewcommand{\@thesis@matriculationnumber}{#1}}
\newcommand{\course}[1]{\renewcommand{\@thesis@course}{#1}}
\newcommand{\studiengang}[1]{\renewcommand{\@thesis@course}{#1}}
%
\newcommand{\advisor}[2][]{%
	\renewcommand{\@thesis@advisor}{#2}%
	\ifthenelse{\equal{#1}{in}}{\renewcommand{\@thesis@advisorsuffix}{in}}{\renewcommand{\@thesis@advisorsuffix}{}}
}
\newcommand{\coadvisor}[2][]{%
	\renewcommand{\@thesis@coadvisor}{#2}
	\ifthenelse{\equal{#1}{in}}{\renewcommand{\@thesis@coadvisorsuffix}{in}}{\renewcommand{\@thesis@coadvisorsuffix}{}}
}
\newcommand{\externaladvisor}[2][]{%
	\renewcommand{\@thesis@externaladvisor}{#2}
	\ifthenelse{\equal{#1}{in}}{\renewcommand{\@thesis@firstexternaladvisorsuffix}{in}\renewcommand{\@thesis@secondexternaladvisorsuffix}{}}{\renewcommand{\@thesis@firstexternaladvisorsuffix}{}\renewcommand{\@thesis@secondexternaladvisorsuffix}{r}}
}
%
\newcommand{\betreuer}{\Examiner}
\newcommand{\zweitgutachter}[2][]{\SecondExaminer[#1]{#2}}
\newcommand{\drittgutachter}{\Supervisor}
%
\newcommand{\betreuerin}[1]{\renewcommand{\@thesis@advisor}{#1}\renewcommand{\@thesis@advisorsuffix}{in}}
\newcommand{\zweitgutachterin}[1]{\renewcommand{\@thesis@coadvisor}{#1}\renewcommand{\@thesis@coadvisorsuffix}{in}}
\newcommand{\drittgutachterin}[1]{\renewcommand{\@thesis@externaladvisor}{#1}\renewcommand{\@thesis@firstexternaladvisorsuffix}{in}\renewcommand{\@thesis@secondexternaladvisorsuffix}{}}
%
%
\newcommand{\logo}[1]{\renewcommand{\@thesis@logo}{#1}}
\newcommand{\extralogo}[2][2.8em]{\renewcommand{\@thesis@additionallogo}{#2}\renewcommand{\@thesis@additionallogoheight}{#1}}
\renewcommand{\maketitle}{%
	{
		%% print title page of the thesis
		\thispagestyle{empty}
		\enlargethispage{2em}
		\vspace*{-1.4em}
		\noindent\includegraphics[height=4.2em,valign=t]{\@thesis@logo}%
		\hspace*{.49em}
		\scalebox{.931}{\parbox[t]{14.7em}{\large\textsf{\@thesis@switchlanguage{Mathematics for Engineers\\{\small Institute for Technologies of Metals}}{Mathematik f\"ur Ingenieure\\{\small Institut f\"ur Technologien der Metalle}}}%
		}}%
		\hfill%
		\ifthenelse{\equal{\@thesis@additionallogo}{}}{}{\includegraphics[height=\@thesis@additionallogoheight]{\@thesis@additionallogo}}%
		\vspace*{1.47em}\par%
		\begin{center}
			\large
			{\textsf{\textbf{\@thesis@switch{Bachelor's Thesis}{Bachelorarbeit}{Master's Thesis}{Masterarbeit}}}\\[1.47em]}
			{\Huge \textsf{\textbf{\@title}\\[.49em]}\vfill\vfill}
			{\normalsize \textsf{\@thesis@switch{Submitted by}{Vorgelegt von}}}\\[1.05em]
			{\LARGE \textsf{\textbf{\@author}}}\\[.49em]
			{\large \textsf{\@thesis@matriculationnumber}}\\[.98em]
			{\normalsize \textsf{\@thesis@switch{to the Faculty of Engineering for the degree of}{an der Fakult\"at f\"ur Ingenieurwissenschaften zur Erlangung des Grades}}}\\[1.05em]
			{\textsf{\textbf{\@thesis@switchdegree{Bachelor}{Master}~of Science}}}\\
			{\textsf{\textbf{\@thesis@course}}}\\[3.43em]
			\vfill%
                {\textsf{\@thesis@switchlanguage{Supervisor}{Betreuer\@thesis@advisorsuffix}}\\}
			{\textsf{\textbf{\@thesis@advisor}\\[3em]}}
			{\textsf{\@thesis@switchlanguage{Second-Supervisor}{Zweitgutachter\@thesis@coadvisorsuffix}}\\}
			{\textsf{\textbf{\@thesis@coadvisor}\\[3em]}}
			\ifthenelse{\equal{\@thesis@externaladvisor}{}}{}{% only if external advirsor has been named
				{\textsf{\@thesis@switchlanguage{External Supervisor}{Betriebliche\@thesis@secondexternaladvisorsuffix\ Gutachter\@thesis@firstexternaladvisorsuffix}}\\}
				{\textsf{\textbf{\@thesis@externaladvisor}\\[3.5em]}}
			}
			\vfill\textsf{\@date}
		\end{center}
		\newpage
		\setcounter{page}{2}
	}
}
%
%
% % "Eidesstattliche Erklaerung" % % % % % % % % % % %
\newcommand{\declaration}{
	\if@thesis@english
		\section*{Declaration in lieu of oath}
		I declare in lieu of oath by my signature below
		\begin{itemize}
			\item that I myself have elaborated this thesis without other help, with exception of guidance by my supervisors,
			\item that I have marked as quotation all text pieces which have been literally or nearly literally adopted from external sources, and
			\item that I have used only the mentioned sources (literature, internet pages, other means), and
			\item that all my statements have been made to the best of my knowledge, that they represent the truth and that I did not conceal anything.
		\end{itemize}
		
		I know that a false declaration in lieu of oath will be punished according to \S156 and \S163 (1) of the German penal code with fine or imprisonment.
	\else
		\section*{Eidesstattliche Erkl\"arung}
		Ich versichere an Eides Statt durch meine untenstehende Unterschrift,
		\begin{itemize}
			\item dass ich die vorliegende Arbeit - mit Ausnahme der Anleitung durch die Betreuer - selbstst\"andig und ohne fremde Hilfe angefertigt habe und
			\item dass ich alle Stellen, die w\"ortlich oder ann\"ahernd w\"ortlich aus fremden Quellen entnommen sind, entsprechend als Zitate gekennzeichnet habe und
			\item dass ich ausschlie\ss lich die angegebenen Quellen (Literatur, Internetseiten, sonstige Hilfsmittel) verwendet habe und
			\item dass ich alle entsprechenden Angaben nach bestem Wissen und Gewissen vorgenommen habe, dass sie der Wahrheit entsprechen und dass ich nichts verschwiegen habe.
		\end{itemize}
		
		Mir ist bekannt, dass eine falsche Versicherung an Eides Statt nach \S156 und nach \S163 Abs.~1 des Strafgesetzbuches mit Freiheitsstrafe oder Geldstrafe bestraft wird.
	\fi
	
	\vspace{4.2em}
	
	\hfill
	\parbox{42mm}{\underline{\hspace*{42mm}}\\[.28em]\centering \smash{\@thesis@switchlanguage{place / date}{Ort, Datum}}}
	\hspace*{2.8em}
	\parbox{42mm}{\underline{\hspace*{42mm}}\\[.28em]\centering \smash{\@author}}
}
%
%
%
% % bibliography configuration % % % % % % % % % % % %
%% package options for biblatex
\PassOptionsToPackage{sorting=\@thesis@sorting,maxcitenames=\@thesis@maxcitenames,maxbibnames=\@thesis@maxbibnames,firstinits=\@thesis@firstinits}{biblatex}
%
%% require bibliography package based on given class options
\if@thesis@usenatbib
	\RequirePackage[numbers,square]{natbib} % natbib is not compatible with biber
	\bibliographystyle{plain}
\else
	\if@thesis@usebibtex
		\RequirePackage[backend=bibtex,defernumbers]{biblatex}	% use biblatex and bibtex
	\else
		\RequirePackage[backend=biber,defernumbers]{biblatex}	% use biblatex and biber
	\fi
\fi
%
%
% % biblatex configuration
\if@thesis@usenatbib
\else % no natbib, i.e. biblatex
	\renewbibmacro{in:}{}				% remove "In: "-prefix from journal field
	\renewrobustcmd*{\bibinitdelim}{\,}	% remove spaces between authors' initials
	\renewcommand*{\bibfont}{}			% do not change font size (should be set in the document)
\fi
%
%
%
\endinput
%
%
%
% % changelog % % % % % % % % % % % % % % % % % % %
%% 0.1
% first version
%
%% 0.2
% changed name
% fixed german language content