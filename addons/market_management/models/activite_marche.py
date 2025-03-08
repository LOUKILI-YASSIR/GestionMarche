from odoo import models, fields, api
from odoo.exceptions import ValidationError

class ActiviteMarche(models.Model):
    _name = "market.activity"
    _description = "Activité du Marché"

    name = fields.Char(string="Nom de l'activité", required=True)
    company_id = fields.Many2one("market.company", string="Entreprise", required=True)
    start_date = fields.Date(string="Date de début")
    end_date = fields.Date(string="Date de fin")
    status = fields.Selection(
        [("brouillon", "Brouillon"), ("actif", "Actif"), ("termine", "Terminé")],
        default="brouillon",
        string="Statut"
    )
    budget = fields.Float(string="Budget")
    location = fields.Char(string="Localisation")
    objective = fields.Text(string="Objectif")
    notes = fields.Text(string="Remarques")

    _sql_constraints = [
        ('check_end_date', 'CHECK(end_date >= start_date)', 'La date de fin doit être postérieure à la date de début.')
    ]

    @api.constrains('budget')
    def _check_budget(self):
        for rec in self:
            if rec.budget is not None and rec.budget < 0:
                raise ValidationError("Le budget doit être une valeur positive.")

    @api.constrains('start_date', 'end_date')
    def _check_dates(self):
        for rec in self:
            if rec.start_date and rec.end_date and rec.end_date < rec.start_date:
                raise ValidationError("La date de fin doit être postérieure à la date de début.")
