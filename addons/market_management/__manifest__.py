{
    "name": "Gestion du Marché",
    "version": "1.0",
    "author": "Loukili Yassir",
    "category": "Ventes",
    "summary": "Gérer les entreprises et activités du marché avec gestion des pays",
    "depends": ["base", "contacts"],
    "data": [
        "views/entreprise_views.xml",
        "views/activite_views.xml",
        "security/ir.model.access.csv",
        "views/actions.xml",
        "views/menus.xml"
    ],
    "installable": True,
    "application": True,
    "license": "LGPL-3",
}
