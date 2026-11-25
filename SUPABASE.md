# Online-Datenbank einrichten (Supabase)

Die App funktioniert ohne Datenbank. Mit einem eigenen, kostenlosen Supabase-Projekt werden Knalle, Notizen und Tonausschnitte zusätzlich online gespeichert und zwischen Geräten abgeglichen.

1. Auf https://supabase.com ein Konto erstellen.
2. «New project»: Name `knall-logger`, Region in Europa (z. B. Zürich oder Frankfurt), Datenbank-Passwort notieren.
3. Links «SQL Editor» › «New query», den Inhalt von [`supabase-setup.sql`](supabase-setup.sql) einfügen und «Run» klicken.
4. «Authentication» › «URL Configuration» › «Site URL» auf `https://kusimanos.github.io/knall-logger/` setzen.
5. Oben «Connect» (oder «Project Settings» › «API»): Projekt-URL und den **öffentlichen** Schlüssel (anon / publishable) kopieren.
6. In der App unter «Mehr» › «Online-Datenbank» beides einfügen, «Verbinden», dann «Konto erstellen», Bestätigungs-Mail öffnen und anmelden.
7. Empfohlen: danach unter «Authentication» › «Sign In / Providers» die Option «Allow new users to sign up» ausschalten.

Schutz: Row Level Security erlaubt jedem Konto nur seine eigenen Zeilen. Tonausschnitte liegen in einem privaten Bucket. Der öffentliche Schlüssel wird nur im Browser gespeichert, nicht in diesem Repository. Den geheimen `service_role`-Schlüssel nie in die App eingeben.
