��    G      T  a   �        o     ?   �  �   �  .   X  #   �     �  '   �     �     �          +  (   :     c  K   z     �     �     �  -   �     	     ,	     4	     B	  8   Y	  M   �	  k   �	  8   L
  (   �
     �
     �
  u   �
     H     M  X   R  @   �     �       ;     6   [  7   �  �   �  /   S  4   �  =   �  Y   �  �  P  )     7   >     v  1   �  '   �  .   �  C     F  b     �  �   �     D     J  n   j     �  @   �     3  &   P     w     z  '   �     �  !   �     �  a        m  �  q  o   B  :   �  �   �  1   �  +   �     
  *   (  	   S     ]     x     �  0   �  !   �  O   �     ;  '   A     i  @   p     �     �     �     �  C   �  T   3  {   �  5     %   :     `  .   g  w   �            c     I   ~     �     �  A   �  H   <  1   �  �   �  >   G  6   �  B   �  \       �  ]       #"  A   D"  $   �"  2   �"  &   �"  -   #  B   3#  a  v#     �$  �   �$     s%  !   {%  X   �%  %   �%  9   &     V&  4   o&     �&     �&  %   �&  '   �&  &   '  #   )'  i   M'     �'        4      '       B                    >                       0      A                    ?       *                  (       3   =   ,   ;                 8   /   <   6               -      E   .   C           9       1                            +   2   #          D   G         :      %      7          !       $   "   )   
      F      	   5   @   &    
        --outdated		Merge in even outdated translations.
	--drop-old-templates	Drop entire outdated templates. 
  -o,  --owner=package		Set the package that owns the command.   -f,  --frontend		Specify debconf frontend to use.
  -p,  --priority		Specify minimum priority question to show.
       --terse			Enable terse mode.
 %s failed to preconfigure, with exit status %s %s is broken or not fully installed %s is fuzzy at byte %s: %s %s is fuzzy at byte %s: %s; dropping it %s is missing %s is missing; dropping %s %s is not installed %s is outdated %s is outdated; dropping whole template! %s must be run as root (Enter zero or more items separated by a comma followed by a space (', ').) Back Cannot read status file: %s Choices Config database not specified in config file. Configuring %s Debconf Debconf on %s Debconf, running at %s Dialog frontend is incompatible with emacs shell buffers Dialog frontend requires a screen at least 13 lines tall and 31 columns wide. Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal. Enter the items you want to select, separated by spaces. Extracting templates from packages: %d%% Help Ignoring invalid priority "%s" Input value, "%s" not found in C choices! This should never happen. Perhaps the templates were incorrectly localized. More Next No usable dialog-like program is installed, so the dialog based frontend cannot be used. Note: Debconf is running in web mode. Go to http://localhost:%i/ Package configuration Preconfiguring packages ...
 Problem setting up the database defined by stanza %s of %s. TERM is not set, so the dialog frontend is not usable. Template #%s in %s does not contain a 'Template:' line
 Template #%s in %s has a duplicate field "%s" with new value "%s". Probably two templates are not properly separated by a lone newline.
 Template database not specified in config file. Template parse error near `%s', in stanza #%s of %s
 Term::ReadLine::GNU is incompatable with emacs shell buffers. The Sigils and Smileys options in the config file are no longer used. Please remove them. The editor-based debconf frontend presents you with one or more text files to edit. This is one such text file. If you are familiar with standard unix configuration files, this file will look familiar to you -- it contains comments interspersed with configuration items. Edit the file, changing any items as necessary, and then save it and exit. At that point, debconf will read the edited file, and use the values you entered to configure the system. This frontend requires a controlling tty. Unable to load Debconf::Element::%s. Failed because: %s Unable to start a frontend: %s Unknown template field '%s', in stanza #%s of %s
 Usage: debconf [options] command [args] Usage: debconf-communicate [options] [package] Usage: debconf-mergetemplate [options] [templates.ll ...] templates Usage: dpkg-reconfigure [options] packages
  -a,  --all			Reconfigure all packages.
  -u,  --unseen-only		Show only not yet seen questions.
       --default-priority	Use default priority instead of low.
       --force			Force reconfiguration of broken packages.
       --no-reload		Do not reload templates. (Use with caution.) Valid priorities are: %s You are using the editor-based debconf frontend to configure your system. See the end of this document for detailed instructions. _Help apt-extracttemplates failed: %s debconf-mergetemplate: This utility is deprecated. You should switch to using po-debconf's po2debconf program. debconf: can't chmod: %s delaying package configuration, since apt-utils is not installed falling back to frontend: %s must specify some debs to preconfigure no none of the above please specify a package to reconfigure template parse error: %s unable to initialize frontend: %s unable to re-open stdin: %s warning: possible database corruption. Will attempt to repair by adding back missing question %s. yes Project-Id-Version: debconf 1.5.32
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2012-06-19 19:05-0400
PO-Revision-Date: 2010-06-09 10:05+0100
Last-Translator: Vanja Cvelbar <cvelbar@gmail.com>
Language-Team: Slovenian <lugos-slo@lugos.si>
Language: sl
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: utf-8
Plural-Forms: nplurals=4; plural=(n%100==1 ? 0 : n%100==2 ? 1 : n%100==3 || n%100==4 ? 2 : 3);
X-Poedit-Language: Slovenian
 
        --outdated		Združi tudi zastarele prevode.
	--drop-old-templates	Popolnoma opusti zastarele predloge. 
  -o,  --owner=paket		Nastavi paket, ki je lastnik ukaza.   -f,  --frontend		Določi začelje, ki naj ga uporablja debconf.
  -p,  --priority		Določi najnižjo prioriteto vprašanj, ki naj bodo prikazana.
       --terse			Uporabi jedrnati način.
 %s napaka pri prednastavljanju, izhodno stanje %s %s je polomljen ali ne popolnoma nameščen %s je nejasna pri bytu %s: %s %s je nejasna pri bytu %s: %s; izpuščena %s manjka %s manjka; izpuščanje %s %s bo nameščen %s je zastarel %s je zastarel; izpuščena bo celotna predloga! %s mora zagnati sistemski skrbnik (Vnesite nič ali več vnosov ločenih z vejico kateri sledi presledek (', ').) Nazaj Ni mogoče brati datoteke s stanjem: %s Izbire V datoteki nastavitev ni določena baza podatkov z nastavitvami. Nastavljanje %s Debconf Debconf pri %s Debconf, zagnan pri %s Začelje za dialog ni združljivo z emacsovimi medpomnilniki lupine Začelje za dialog potrebuje zaslon visok vsak 13 vrstic in širok vsaj 31 stolpcev. Začelje za dialog ne bo delovalo s pasivnim terminalom, z emacsovim medpomnilnikom lupine ali pa brez nadzornega terminala Vnose, ki jih želite, vpišite ločeno s presledkom. Razširjanje predlog iz paketov: %d%% Pomoč Neveljavne prioritete ne bodo upoštevane "%s" V izbirah C ni bilo najti vrednosti vnosa "%s"! To se ne sme zgoditi, Mogoče je bila predloga nepravilno lokalizirana. Več Naprej Noben dialogu podoben program ni nameščen, zaradi tega začelja za dialog ni mogoče uporabljati. Opomba: Debconf teče v spletnem načinu. Pojdite na http://localhost:%i/ Nastavljanje paketa Prednastavljanje paketov ...
 Napaka pri nastavitvi baze podatkov določene v stavku  %s od %s. TERM ni nastavljen, zaradi tega ni mogoče uporabiti začelja za dialog. Predloga #%s v %s ne vsebuje vrstice 'Template:'
 Predloga #%s v %s vsebuje podvojeno polje "%s" z novo vrednostjo "%s". Verjetno dve predlogi nista pravilno ločeni s samostojno novo vrstico.
 V datoteki nastavitev ni določena baza podatkov s predlogami. Napaka v predlogi v bližini `%s', v stavku #%s od %s
 Term::ReadLine::GNU ni združljiv z medpomnilniki emacs za lupino. Možnosti Sigils in Smileys v nastavitveni datoteki niso več v rabi. Odstranite jih prosim. Začelje debconf osnovano na urejevalniku vam prikaže eno ali več besedilnih datotek za urejanje. To je ena izmed teh datotek. V primeru, da poznate standardne nastavitvene datoteke unix vam bo datoteka domača -- v njej so opombe in vrinjeni nastavitveni elementi. Uredite datoteko, spremenite potrebne elemente, shranite jo in zaprite. Takrat bo debconf pregledal spremenjeno datoteko in uporabil vrednosti, ki ste jih vpisali za nastavitev sistema. Začelje potrebuje nadzorni tty. Ni bilo mogoče naložiti Debconf::Element::%s. Napaka zaradi: %s Začelja ni bilo mogoče zagnati: %s Neznano polje `%s' v predlogi, v stavku #%s od %s
 Uporaba: debconf [izbira] ukaz [paket] Uporaba: debconf-communicate [izbira] [paket] Uporaba: debconf-mergetemplate [izbira] [predloge.ll ...] predloge Uporaba: debconf-reconfigure [izbira] paketi
  -a,  --all			Ponovno nastavi vse pakete.
  -u,  --unseen-only		Pokaži samo ne že videna vprašanja.
       --default-priority	Uporabi privzeto prioriteto namesto nizke.
       --force			Vsili ponovno nastavitev polomljenih paketov.
       --no-reload		Ne nalagaj ponovno predlog. (Uporabljajte pazljivo.) Veljavne prioritete: %s Za nastavitev sistema uporabljate začelje debconf osnovano na urejevalniku. Na koncu tega dokumenta dobite podrobnejša navodila. _Pomoč apt-extracttemplates ni uspel: %s debconf-mergetemplate: To orodje je zastarelo. Uporabljati bi morali program po-debconf. debconf: ni mogoče izvesti chmod: %s zakasnitev nastavitve paketov ker apt-utils ni nameščen vračanje v začelje: %s določiti morate nekaj paketov deb za prednastavitev ne nič od tega določite paket za ponovno nastavitev napaka pri razćlenjevanju predloge: %s začelja ni bilo mogoče nastaviti: %s ni mogoče ponovno odprti stdin: %s pozor: možna napaka v bazi podatkov. Poskus popravljanje s ponovnim dodajanjem manjkajočih vprašanj %s da 