//Collection vehicules
{
    "numVehicule": 1,
    "numImmat": "0012519216",
    "annee": 1992,
    "modele": {
        "numModele": 6,
        "marque": {
            "numMarque": 17,
            "nomMarque": "RENAULT",
            "pays": "FRANCE"
        },
        "nomModele": "Safrane"
    },
    "interventions": [
        {
            "numIntervention": 7,
            "typeIntervention": "Entretien",
            "dateDeb": ISODate("2006-04-09T09:00:00Z"),
            "dateFin": ISODate("2006-04-09T18:00:00Z"),
            "cout": 8000,
            "employes": [
                {
                    "numEmploye": 55,
                    "nom": "HADJ",
                    "prenom": "Zouhir",
                    "categorie": "Assistant",
                    "salaire": 12000,
                    "dateDeb": ISODate("2006-04-09T14:00:00Z"),
                    "dateFin": ISODate("2006-04-09T18:00:00Z")
                },
                {
                    "numEmploye": 65,
                    "nom": "MOHAMMEDI",
                    "prenom": "Mustapha",
                    "categorie": "Mécanicien",
                    "salaire": 24000,
                    "dateDeb": ISODate("2006-04-09T09:00:00Z"),
                    "dateFin": ISODate("2006-04-09T12:00:00Z")
                }
            ]
        },
        {
            "numIntervention": 14,
            "typeIntervention": "Réparation",
            "dateDeb": ISODate("2006-05-10T14:00:00Z"),
            "dateFin": ISODate("2006-05-12T12:00:00Z"),
            "cout": 39000,
            "employes": [
                {
                    "numEmploye": 88,
                    "nom": "LARDJOUNE",
                    "prenom": "Karim",
                    "categorie": "Mécanicien",
                    "salaire": 25000,
                    "dateDeb": ISODate("2006-05-07T14:00:00Z"),
                    "dateFin": ISODate("2006-05-10T18:00:00Z")
                }
            ]
        }
    ]
}


db.vehicules.insertMany([
    {
      "numVehicule": 1,
      "numImmat": "0012519216",
      "annee": 1992,
      "modele": {
        "numModele": 6,
        "marque": {
          "numMarque": 17,
          "nomMarque": "RENAULT",
          "pays": "FRANCE"
        },
        "nomModele": "Safrane"
      },
      "interventions": [
        {
          "numIntervention": 7,
          "typeIntervention": "Entretien",
          "dateDeb": ISODate("2006-04-09T09:00:00Z"),
          "dateFin": ISODate("2006-04-09T18:00:00Z"),
          "cout": 8000,
          "employes": [
            {
              "numEmploye": 55,
              "nom": "HADJ",
              "prenom": "Zouhir",
              "categorie": "Assistant",
              "salaire": 12000,
              "dateDeb": ISODate("2006-04-09T14:00:00Z"),
              "dateFin": ISODate("2006-04-09T18:00:00Z")
            },
            {
              "numEmploye": 65,
              "nom": "MOHAMMEDI",
              "prenom": "Mustapha",
              "categorie": "Mécanicien",
              "salaire": 24000,
              "dateDeb": ISODate("2006-04-09T09:00:00Z"),
              "dateFin": ISODate("2006-04-09T12:00:00Z")
            }
          ]
        },
        {
          "numIntervention": 14,
          "typeIntervention": "Réparation",
          "dateDeb": ISODate("2006-05-10T14:00:00Z"),
          "dateFin": ISODate("2006-05-12T12:00:00Z"),
          "cout": 39000,
          "employes": [
            {
              "numEmploye": 88,
              "nom": "LARDJOUNE",
              "prenom": "Karim",
              "categorie": "Mécanicien",
              "salaire": 25000,
              "dateDeb": ISODate("2006-05-07T14:00:00Z"),
              "dateFin": ISODate("2006-05-10T18:00:00Z")
            }
          ]
        }
      ]
    },
    {
      "numVehicule": 2,
      "numImmat": "0124219316",
      "annee": 1993,
      "modele": {
        "numModele": 20,
        "marque": {
          "numMarque": 9,
          "nomMarque": "JAGUAR",
          "pays": "GRANDE-BRETAGNE"
        },
        "nomModele": "XJ 8"
      },
      "interventions": [
        {
          "numIntervention": 10,
          "typeIntervention": "Entretien et Réparation",
          "dateDeb": ISODate("2006-04-08T09:00:00Z"),
          "dateFin": ISODate("2006-04-09T18:00:00Z"),
          "cout": 45000,
          "employes": [
            {
              "numEmploye": 63,
              "nom": "CHAOUI",
              "prenom": "Ismail",
              "categorie": "Assistant",
              "salaire": 13000,
              "dateDeb": ISODate("2006-04-09T14:00:00Z"),
              "dateFin": ISODate("2006-04-09T18:00:00Z")
            },
            {
              "numEmploye": 67,
              "nom": "SAIDOUNI",
              "prenom": "Wahid",
              "categorie": "Mécanicien",
              "salaire": 25000,
              "dateDeb": ISODate("2006-04-08T09:00:00Z"),
              "dateFin": ISODate("2006-04-09T12:00:00Z")
            }
          ]
        }
      ]
    },
    {
      "numVehicule": 3,
      "numImmat": "1452318716",
      "annee": 1987,
      "modele": {
        "numModele": 8,
        "marque": {
          "numMarque": 12,
          "nomMarque": "LOTUS",
          "pays": "GRANDE-BRETAGNE"
        },
        "nomModele": "Esprit"
      },
      "interventions": [
        {
          "numIntervention": 1,
          "typeIntervention": "Réparation",
          "dateDeb": ISODate("2006-02-25T09:00:00Z"),
          "dateFin": ISODate("2006-02-26T12:00:00Z"),
          "cout": 30000,
          "employes": [
            {
              "numEmploye": 54,
              "nom": "BOUCHEMLA",
              "prenom": "Elias",
              "categorie": "Assistant",
              "salaire": 10000,
              "dateDeb": ISODate("2006-02-26T09:00:00Z"),
              "dateFin": ISODate("2006-02-26T12:00:00Z")
            },
            {
              "numEmploye": 59,
              "nom": "BELHAMIDI",
              "prenom": "Mourad",
              "categorie": "Mécanicien",
              "salaire": 19500,
              "dateDeb": ISODate("2006-02-25T09:00:00Z"),
              "dateFin": ISODate("2006-02-25T18:00:00Z")
            }
          ]
        }
      ]
    },
    {
      "numVehicule": 4,
      "numImmat": "3145219816",
      "annee": 1998,
      "modele": {
        "numModele": 12,
        "marque": {
          "numMarque": 3,
          "nomMarque": "ROLLS-ROYCE",
          "pays": "GRANDE-BRETAGNE"
        },
        "nomModele": "Bentley-Continental"
      }
    },
    {
      "numVehicule": 5,
      "numImmat": "1278919816",
      "annee": 1998,
      "modele": {
        "numModele": 23,
        "marque": {
          "numMarque": 14,
          "nomMarque": "MERCEDES",
          "pays": "ALLEMAGNE"
        },
        "nomModele": "Classe E"
      }
    },
    {
      "numVehicule": 6,
      "numImmat": "3853319735",
      "annee": 1997,
      "modele": {
        "numModele": 6,
        "marque": {
          "numMarque": 17,
          "nomMarque": "RENAULT",
          "pays": "FRANCE"
        },
        "nomModele": "Safrane"
      },
      "interventions": [
        {
          "numIntervention": 5,
          "typeIntervention": "Réparation",
          "dateDeb": ISODate("2006-02-22T09:00:00Z"),
          "dateFin": ISODate("2006-02-25T18:00:00Z"),
          "cout": 40000,
          "employes": [
            {
              "numEmploye": 56,
              "nom": "OUSSEDIK



              {
                "numVehicule": 7,
                "numImmat": "1453119816",
                "annee": 1998,
                "modele": {
                  "numModele": 8,
                  "marque": {
                    "numMarque": 12,
                    "nomMarque": "LOTUS",
                    "pays": "GRANDE-BRETAGNE"
                  },
                  "nomModele": "Esprit"
                },
                "interventions": [
                  {
                    "numIntervention": 23,
                    "typeIntervention": "Réparation",
                    "dateDeb": ISODate("1985-01-01T09:00:00Z"),
                    "dateFin": ISODate("1985-01-01T18:00:00Z"),
                    "cout": 16789,
                    "employes": [
                      {
                        "numEmploye": 59,
                        "nom": "BELHAMIDI",
                        "prenom": "Mourad",
                        "categorie": "Mécanicien",
                        "salaire": 19500
                      }
                    ]
                  }
                ]
              },
              {
                "numVehicule": 8,
                "numImmat": "8365318601",
                "annee": 1986,
                "modele": {
                  "numModele": 14,
                  "marque": {
                    "numMarque": 13,
                    "nomMarque": "MASERATI",
                    "pays": "ITALIE"
                  },
                  "nomModele": "Evoluzione"
                },
                "interventions": [
                  {
                    "numIntervention": 13,
                    "typeIntervention": "Réparation Système",
                    "dateDeb": ISODate("2006-05-12T14:00:00Z"),
                    "dateFin": ISODate("2006-05-12T18:00:00Z"),
                    "cout": 17846,
                    "employes": [
                      {
                        "numEmploye": 64,
                        "nom": "BADI",
                        "prenom": "Hatem",
                        "categorie": "Assistant",
                        "salaire": 14000,
                        "dateDeb": ISODate("2006-05-12T14:00:00Z"),
                        "dateFin": ISODate("2006-05-12T18:00:00Z")
                      }
                    ]
                  }
                ]
              },
              {
                "numVehicule": 9,
                "numImmat": "3087319233",
                "annee": 1992,
                "modele": {
                  "numModele": 15,
                  "marque": {
                    "numMarque": 16,
                    "nomMarque": "PORSCHE",
                    "pays": "ALLEMAGNE" 
                  },
                  "nomModele": "Carrera"
                }
              },
              {
                "numVehicule": 10,
                "numImmat": "9413119935",
                "annee": 1999,
                "modele": {
                  "numModele": 22,
                  "marque": {
                    "numMarque": 20,
                    "nomMarque": "VENTURI",
                    "pays": "FRANCE"
                  },
                  "nomModele": "300 Atlantic"
                },
                "interventions": [
                  {
                    "numIntervention": 4,
                    "typeIntervention": "Entretien",
                    "dateDeb": ISODate("2006-05-14T09:00:00Z"),
                    "dateFin": ISODate("2006-05-14T18:00:00Z"),
                    "cout": 10000,
                    "employes": [
                      {
                        "numEmploye": 62,
                        "nom": "RAHALI",
                        "prenom": "Ahcene",
                        "categorie": "Mécanicien",
                        "salaire": 24000,
                        "dateDeb": ISODate("2006-05-14T09:00:00Z"),
                        "dateFin": ISODate("2006-05-14T12:00:00Z")
                      },
                      {
                        "numEmploye": 66,
                        "nom": "FEKAR",
                        "prenom": "Abdelaziz",
                        "categorie": "Assistant",
                        "salaire": 13500,
                        "dateDeb": ISODate("2006-02-14T14:00:00Z"),
                        "dateFin": ISODate("2006-05-14T18:00:00Z")
                      }
                    ]
                  },
                  {
                    "numIntervention": 27,
                    "typeIntervention": "Réparation",
                    "dateDeb": ISODate("1998-01-01T09:00:00Z"),
                    "dateFin": ISODate("1998-01-04T18:00:00Z"),
                    "cout": 12560,
                    "employes": [
                      {
                        "numEmploye": 59,
                        "nom": "BELHAMIDI",
                        "prenom": "Mourad",
                        "categorie": "Mécanicien",
                        "salaire": 19500
                      }
                    ]
                  }
                ]
              },
              {
                "numVehicule": 11,
                "numImmat": "1572319801",
                "annee": 1998,
                "modele": {
                  "numModele": 16,
                  "marque": {
                    "numMarque": 16,
                    "nomMarque": "PORSCHE",
                    "pays": "ALLEMAGNE"
                  },
                  "nomModele": "Boxter" 
                }
              },
              {
                "numVehicule": 12,
                "numImmat": "6025319733",
                "annee": 1997,
                "modele": {
                  "numModele": 20,
                  "marque": {
                    "numMarque": 9,
                    "nomMarque": "JAGUAR",
                    "pays": "GRANDE-BRETAGNE"
                  },
                  "nomModele": "XJ 8"
                }
              },
              {
                "numVehicule": 13,
                "numImmat": "5205319736",
                "annee": 1997,
                "modele": {
                  "numModele": 17,
                  "marque": {
                    "numMarque": 21,
                    "nomMarque": "VOLVO",
                    "pays": "SUEDE"
                  },
                  "nomModele": "S 80"
                },
                "interventions": [
                  {
                    "numIntervention": 25,
                    "typeIntervention": "Réparation",
                    "dateDeb": ISODate("1998-01-01T09:00:00Z"),
                    "dateFin": ISODate("1998-01-03T18:00:00Z"),
                    "cout": 12789,
                    "employes": [
                      {
                        "numEmploye": 58,
                        "nom": "BABACI",
                        "prenom": "Tayeb", 
                        "categorie": "Mécanicien",
                        "salaire": 21300
                      }
                    ]
                  }
                ]
              },
              {
                "numVehicule": 14,
                "numImmat": "7543119207",
                "annee": 1992,
                "modele": {
                  "numModele": 21,
                  "marque": {
                    "numMarque": 15,
                    "nomMarque": "PEUGEOT",
                    "pays": "FRANCE"
                  },
                  "nomModele": "406 Coupé"
                },
                "interventions": [
                  {
                    "numIntervention": 6,
                    "typeIntervention": "Entretien",
                    "dateDeb": ISODate("2006-03-03T14:00:00Z"),
                    "dateFin": ISODate("2006-03



                    {
                        "numVehicule": 15,
                        "numImmat": "6254319916",
                        "annee": 1999,
                        "modele": {
                          "numModele": 19,
                          "marque": {
                            "numMarque": 4,
                            "nomMarque": "BMW",
                            "pays": "ALLEMAGNE"
                          },
                          "nomModele": "M 3"
                        }
                      },
                      {
                        "numVehicule": 16,
                        "numImmat": "9831419701",
                        "annee": 1997,
                        "modele": {
                          "numModele": 21,
                          "marque": {
                            "numMarque": 15,
                            "nomMarque": "PEUGEOT",
                            "pays": "FRANCE"
                          },
                          "nomModele": "406 Coupé"
                        },
                        "interventions": [
                          {
                            "numIntervention": 8,
                            "typeIntervention": "Entretien",
                            "dateDeb": ISODate("2006-05-11T14:00:00Z"),
                            "dateFin": ISODate("2006-05-12T18:00:00Z"),
                            "cout": 9000,
                            "employes": [
                              {
                                "numEmploye": 54,
                                "nom": "BOUCHEMLA",
                                "prenom": "Elias",
                                "categorie": "Assistant",
                                "salaire": 10000,
                                "dateDeb": ISODate("2006-05-12T09:00:00Z"),
                                "dateFin": ISODate("2006-05-12T18:00:00Z")
                              },
                              {
                                "numEmploye": 62,
                                "nom": "RAHALI",
                                "prenom": "Ahcene",
                                "categorie": "Mécanicien",
                                "salaire": 24000,
                                "dateDeb": ISODate("2006-05-11T14:00:00Z"),
                                "dateFin": ISODate("2006-05-12T12:00:00Z")
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "numVehicule": 17,
                        "numImmat": "4563117607",
                        "annee": 1976,
                        "modele": {
                          "numModele": 11,
                          "marque": {
                            "numMarque": 7,
                            "nomMarque": "FERRARI",
                            "pays": "ITALIE"
                          },
                          "nomModele": "550 Maranello"
                        }
                      },
                      {
                        "numVehicule": 18,
                        "numImmat": "7973318216",
                        "annee": 1982,
                        "modele": {
                          "numModele": 2,
                          "marque": {
                            "numMarque": 1,
                            "nomMarque": "LAMBORGHINI",
                            "pays": "ITALIE"
                          },
                          "nomModele": "Diablo"
                        }
                      },
                      {
                        "numVehicule": 19,
                        "numImmat": "3904318515",
                        "annee": 1985,
                        "modele": {
                          "numModele": 77,
                          "marque": {
                            "numMarque": 7,
                            "nomMarque": "FERRARI",
                            "pays": "ITALIE"
                          },
                          "nomModele": "F 355"
                        },
                        "interventions": [
                          {
                            "numIntervention": 16,
                            "typeIntervention": "Réparation",
                            "dateDeb": ISODate("2006-06-27T09:00:00Z"),
                            "dateFin": ISODate("2006-06-30T12:00:00Z"),
                            "cout": 25000,
                            "employes": [
                              {
                                "numEmploye": 61,
                                "nom": "KOULA",
                                "prenom": "Bahim",
                                "categorie": "Mécanicien",
                                "salaire": 23100
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "numVehicule": 20,
                        "numImmat": "1234319707",
                        "annee": 1997,
                        "modele": {
                          "numModele": 2,
                          "marque": {
                            "numMarque": 1,
                            "nomMarque": "LAMBORGHINI",
                            "pays": "ITALIE"
                          },
                          "nomModele": "Diablo"
                        },
                        "interventions": [
                          {
                            "numIntervention": 12,
                            "typeIntervention": "Entretien et Réparation", 
                            "dateDeb": ISODate("2006-05-03T09:00:00Z"),
                            "dateFin": ISODate("2006-05-05T18:00:00Z"),
                            "cout": 27000,
                            "employes": [
                              {
                                "numEmploye": 55,
                                "nom": "HADJ",
                                "prenom": "Zouhir",
                                "categorie": "Assistant",
                                "salaire": 12000,
                                "dateDeb": ISODate("2006-05-05T09:00:00Z"),
                                "dateFin": ISODate("2006-05-05T18:00:00Z")
                              },
                              {
                                "numEmploye": 56,
                                "nom": "OUSSEDIK",
                                "prenom": "Hakim",
                                "categorie": "Mécanicien",
                                "salaire": 20000,
                                "dateDeb": ISODate("2006-05-03T09:00:00Z"),
                                "dateFin": ISODate("2006-05-05T12:00:00Z")
                              }
                            ]
                          },
                          {
                            "numIntervention": 15,
                            "typeIntervention": "Réparation Système",
                            "dateDeb": ISODate("2006-06-25T09:00:00Z"),
                            "dateFin": ISODate("2006-06-25T12:00:00Z"),
                            "cout": 27000,
                            "employes": [
                              {
                                "numEmploye": 71,
                                "nom": "TERKI",
                                "prenom": "Yacine",
                                "categorie": "Mécanicien",
                                "salaire": 23000,
                                "dateDeb": ISODate("2006-06-25T09:00:00Z"),
                                "dateFin": ISODate("2006-06-25T12:00:00Z")
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "numVehicule": 21,
                        "numImmat": "8429318516",
                        "annee": 1985,
                        "modele": {
                          "numModele": 19,
                          "marque": {
                            "numMarque": 4,
                            "nomMarque": "BMW",
                            "pays": "ALLEMAGNE"
                          },
                          "nomModele": "M 3"
                        },
                        "interventions": [
                          {
                            "numIntervention": 2,
                            "typeIntervention": "Réparation",
                            "dateDeb": ISODate("2006-02-23T09:00:00Z"),
                            "dateFin": ISODate("2006-02-24T18:00:00Z"),
                            "cout": 10000,
                            "employes": [
                              {
                                "numEmploye": 57,
                                "nom": "ABAD",
                                "prenom": "Abdelhamid",
                                "categorie": "Assistant",
                                "salaire": 13000,
                                "dateDeb": ISODate("2006-02-24T14:00:00Z"),
                                "dateFin": ISODate("2006-02-24


                                {
                                    "numVehicule": 22,
                                    "numImmat": "1245619816", 
                                    "annee": 1998,
                                    "modele": {
                                      "numModele": 19,
                                      "marque": {
                                        "numMarque": 4,
                                        "nomMarque": "BMW",
                                        "pays": "ALLEMAGNE"
                                      },
                                      "nomModele": "M 3"
                                    },
                                    "interventions": [
                                      {
                                        "numIntervention": 9,
                                        "typeIntervention": "Entretien",
                                        "dateDeb": ISODate("2006-02-22T09:00:00Z"),
                                        "dateFin": ISODate("2006-02-22T18:00:00Z"),
                                        "cout": 7960,
                                        "employes": [
                                          {
                                            "numEmploye": 59,
                                            "nom": "BELHAMIDI",
                                            "prenom": "Mourad",
                                            "categorie": "Mécanicien",
                                            "salaire": 19500,
                                            "dateDeb": ISODate("2006-02-22T09:00:00Z"),
                                            "dateFin": ISODate("2006-02-22T12:00:00Z")
                                          },
                                          {
                                            "numEmploye": 60,
                                            "nom": "IGOUDJIL",
                                            "prenom": "Redouane", 
                                            "categorie": "Assistant",
                                            "salaire": 15000,
                                            "dateDeb": ISODate("2006-02-22T14:00:00Z"),
                                            "dateFin": ISODate("2006-02-22T18:00:00Z")
                                          }
                                        ]
                                      }
                                    ]
                                  },
                                  {
                                    "numVehicule": 23,
                                    "numImmat": "1678918516",
                                    "annee": 1985,
                                    "modele": {
                                      "numModele": 25,
                                      "marque": {
                                        "numMarque": 5,
                                        "nomMarque": "CADILLAC",
                                        "pays": "ETATS-UNIS"
                                      },
                                      "nomModele": "Séville"
                                    }
                                  },
                                  {
                                    "numVehicule": 24,
                                    "numImmat": "1789519816",
                                    "annee": 1998,
                                    "modele": {
                                      "numModele": 9,
                                      "marque": {
                                        "numMarque": 15,
                                        "nomMarque": "PEUGEOT",
                                        "pays": "FRANCE" 
                                      },
                                      "nomModele": "605"
                                    },
                                    "interventions": [
                                      {
                                        "numIntervention": 24,
                                        "typeIntervention": "Réparation",
                                        "dateDeb": ISODate("1998-01-01T09:00:00Z"),
                                        "dateFin": ISODate("1998-01-04T18:00:00Z"),
                                        "cout": 17895,
                                        "employes": [
                                          {
                                            "numEmploye": 80,
                                            "nom": "LARDJOUNE",
                                            "prenom": "Karim",
                                            "categorie": "Mécanicien",
                                            "salaire": 25000
                                          }
                                        ]
                                      }
                                    ]
                                  },
                                  {
                                    "numVehicule": 25,
                                    "numImmat": "1278919833",
                                    "annee": 1998,
                                    "modele": {
                                      "numModele": 5,
                                      "marque": {
                                        "numMarque": 14,
                                        "nomMarque": "MERCEDES",
                                        "pays": "ALLEMAGNE"
                                      },
                                      "nomModele": "Classe C"
                                    },
                                    "interventions": [
                                      {
                                        "numIntervention": 3,
                                        "typeIntervention": "Réparation",
                                        "dateDeb": ISODate("2006-04-06T14:00:00Z"),
                                        "dateFin": ISODate("2006-04-09T12:00:00Z"),
                                        "cout": 42000,
                                        "employes": [
                                          {
                                            "numEmploye": 60,
                                            "nom": "IGOUDJIL",
                                            "prenom": "Redouane",
                                            "categorie": "Assistant",
                                            "salaire": 15000,
                                            "dateDeb": ISODate("2006-04-09T09:00:00Z"),
                                            "dateFin": ISODate("2006-04-09T12:00:00Z")
                                          },
                                          {
                                            "numEmploye": 65,
                                            "nom": "MOHAMMEDI",
                                            "prenom": "Mustapha",
                                            "categorie": "Mécanicien",
                                            "salaire": 24000,
                                            "dateDeb": ISODate("2006-04-06T14:00:00Z"),
                                            "dateFin": ISODate("2006-04-08T18:00:00Z")  
                                          }
                                        ]
                                      }
                                    ]
                                  },
                                  {
                                    "numVehicule": 26,
                                    "numImmat": "1458919316",
                                    "annee": 1993,
                                    "modele": {
                                      "numModele": 10,
                                      "marque": {
                                        "numMarque": 19,
                                        "nomMarque": "TOYOTA",
                                        "pays": "JAPON"
                                      },
                                      "nomModele": "Prévia"
                                    }
                                  },
                                  {
                                    "numVehicule": 27,
                                    "numImmat": "1256019804",
                                    "annee": 1998,
                                    "modele": {
                                      "numModele": 7,
                                      "marque": {
                                        "numMarque": 20,
                                        "nomMarque": "VENTURI",
                                        "pays": "FRANCE"
                                      },
                                      "nomModele": "400 GT"
                                    }
                                  },
                                  {
                                    "numVehicule": 28,
                                    "numImmat": "1986219904",
                                    "annee": 1999,
                                    "modele": {
                                      "numModele": 3,
                                      "marque": {
                                        "numMarque": 2,
                                        "nomMarque": "AUDI",
                                        "pays": "ALLEMAGNE"
                                      },
                                      "nomModele": "Série 5"
                                    },
                                    "interventions": [
                                      {
                                        "numIntervention": 11,
                                        "typeIntervention": "Réparation",
                                        "dateDeb": ISODate("2006-03-08T14:00:00Z"),
                                        "dateFin": ISODate("2006-03-17T12:00:00Z"),
                                        "cout": 36000,
                                        "employes": [
                                          {
                                            "numEmploye": 53,
                                            "nom": "LACHEMI",
                                            "prenom": "Bouzid",
                                            "categorie": "Mécanicien", 
                                            "salaire": 25000,
                                            "dateDeb": ISODate("2006-03-08T14:00:00Z"),
                                            "dateFin": ISODate("2006-03-16T18:00:00Z")
                                          },
                                          {
                                            "numEmploye": 59,
                                            "nom": "BELHAMIDI",
                                            "prenom": "Mourad",
                                            "categorie": "Mécanicien",
                                            "salaire": 19500,
                                            "dateDeb": ISODate("2006-03-09T09:00:00Z"),
                                            "dateFin": ISODate("2006-03-11T18:00:00Z")  
                                          },
                                          {
                                            "numEmploye": 64,
                                            "nom": "BADI",
                                            "prenom": "Hatem",
                                            "categorie": "Assistant",
                                            "salaire": 14000,
                                            "dateDeb": ISODate("2006-03-09T09:00:00Z"),
                                            "dateFin":



                                            {
                                                "numVehicule": 28,
                                                "numImmat": "1986219904",
                                                "annee": 1999,
                                                "modele": {
                                                  "numModele": 3,
                                                  "marque": {
                                                    "numMarque": 2,
                                                    "nomMarque": "AUDI",
                                                    "pays": "ALLEMAGNE"
                                                  },
                                                  "nomModele": "Série 5"
                                                },
                                                "interventions": [
                                                  {
                                                    "numIntervention": 11,
                                                    "typeIntervention": "Réparation",
                                                    "dateDeb": ISODate("2006-03-08T14:00:00Z"),
                                                    "dateFin": ISODate("2006-03-17T12:00:00Z"),
                                                    "cout": 36000,
                                                    "employes": [
                                                      {
                                                        "numEmploye": 53,
                                                        "nom": "LACHEMI",
                                                        "prenom": "Bouzid",
                                                        "categorie": "Mécanicien",
                                                        "salaire": 25000,
                                                        "dateDeb": ISODate("2006-03-08T14:00:00Z"),
                                                        "dateFin": ISODate("2006-03-16T18:00:00Z")
                                                      },
                                                      {
                                                        "numEmploye": 59,
                                                        "nom": "BELHAMIDI",
                                                        "prenom": "Mourad",
                                                        "categorie": "Mécanicien",
                                                        "salaire": 19500,
                                                        "dateDeb": ISODate("2006-03-09T09:00:00Z"),
                                                        "dateFin": ISODate("2006-03-11T18:00:00Z")
                                                      },
                                                      {
                                                        "numEmploye": 64,
                                                        "nom": "BADI",
                                                        "prenom": "Hatem",
                                                        "categorie": "Assistant",
                                                        "salaire": 14000,
                                                        "dateDeb": ISODate("2006-03-09T09:00:00Z"),
                                                        "dateFin": ISODate("2006-03-17T12:00:00Z")
                                                      }
                                                    ]
                                                  }
                                                ]
                                              },
                                              {
                                                "numVehicule": 29,
                                                "numImmat": "4563145633",
                                                "annee": 2000,
                                                "modele": {
                                                  "numModele": 29,
                                                  "marque": {
                                                    "numMarque": 18,
                                                    "nomMarque": "SAAB",
                                                    "pays": "SUEDE"
                                                  },
                                                  "nomModele": "POLO"
                                                }
                                              }
                                              ])