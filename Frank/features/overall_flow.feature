Feature: High-level flow through the application

Background:
  Given I launch the app

Scenario: list creation flow
  Given I am on the Lists screen
  When I choose to add a list called "Monkeys"
  Then I should be on the Tasks screen for the "Monkeys" list
  And I should be prompted for my first task

  When I enter a task name of "Bonobo"
  And I tap out of task entry mode
  Then I should see a tasks list of:
    |Bonobo|
