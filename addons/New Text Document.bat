@echo off
echo Creating Odoo module structure... (Création de la structure du module Odoo...)
mkdir market_management
cd market_management

echo Creating directories... (Création des répertoires...)
mkdir models
mkdir views
mkdir security

echo Creating files... (Création des fichiers...)
echo. > __init__.py
echo. > __manifest__.py

cd models
echo. > __init__.py
echo. > market_company.py
echo. > market_management.py
cd ..

cd views
echo. > market_company_views.xml
echo. > market_management_views.xml
echo. > menu_views.xml
cd ..

cd security
echo. > ir.model.access.csv
cd ..

echo Module structure created successfully! (Structure du module créée avec succès!)
pause
