from odoo import models, fields, api
import re
from odoo.exceptions import ValidationError

class EntrepriseMarche(models.Model):
    _name = "market.company"
    _description = "Entreprise du Marché"

    name = fields.Char(string="Nom de l'entreprise", required=True)
    industry = fields.Char(string="Secteur")
    phone = fields.Char(string="Téléphone")
    registration_date = fields.Date(string="Date d'enregistrement", default=fields.Date.today)
    address = fields.Text(string="Adresse")
    website = fields.Char(string="Site Web")
    description = fields.Text(string="Description")
    country_id = fields.Many2one('res.country', string="Pays")

    @api.constrains('phone')
    def _check_phone(self):
        for rec in self:
            if rec.phone and not re.match(r'^\+?\d[\d -]{7,}\d$', rec.phone):
                raise ValidationError("Veuillez saisir un numéro de téléphone valide.")

    @api.constrains('registration_date')
    def _check_registration_date(self):
        for rec in self:
            if rec.registration_date and rec.registration_date > fields.Date.today():
                raise ValidationError("La date d'enregistrement ne peut pas être dans le futur.")
