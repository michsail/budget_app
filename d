import tkinter as tk
from tkinter import messagebox
import pandas as pd
import matplotlib.pyplot as plt

class BudgetManager:
    def __init__(self, root):
        self.root = root
        self.root.title("Менеджер бюджета")

        # Инициализация переменных
        self.income = 0
        self.expenses = {}

        # Создание фрейма для ввода дохода
        self.income_frame = tk.Frame(root)
        self.income_frame.pack(pady=10)

        self.income_label = tk.Label(self.income_frame, text="Введите доход (₽):")
        self.income_label.pack(side=tk.LEFT)

        self.income_entry = tk.Entry(self.income_frame, width=15)
        self.income_entry.pack(side=tk.LEFT)

        self.add_income_button = tk.Button(self.income_frame, text="Добавить доход", command=self.add_income)
        self.add_income_button.pack(side=tk.LEFT)

        # Создание фрейма для ввода расхода
        self.expense_frame = tk.Frame(root)
        self.expense_frame.pack(pady=10)

        self.expense_label = tk.Label(self.expense_frame, text="Категория расхода:")
        self.expense_label.pack(side=tk.LEFT)

        self.expense_category_entry = tk.Entry(self.expense_frame, width=15)
        self.expense_category_entry.pack(side=tk.LEFT)

        self.expense_amount_label = tk.Label(self.expense_frame, text="Сумма (₽):")
        self.expense_amount_label.pack(side=tk.LEFT)

        self.expense_amount_entry = tk.Entry(self.expense_frame, width=10)
        self.expense_amount_entry.pack(side=tk.LEFT)

        self.add_expense_button = tk.Button(self.expense_frame, text="Добавить расход", command=self.add_expense)
        self.add_expense_button.pack(side=tk.LEFT)

        # Кнопка для отображения графика
        self.plot_button = tk.Button(root, text="Показать график расходов", command=self.plot_expenses)
        self.plot_button.pack(pady=10)

        # Отображение баланса
        self.balance_frame = tk.Frame(root)
        self.balance_frame.pack(pady=10)

        self.balance_label = tk.Label(self.balance_frame, text="Баланс: 0 ₽", font=("Arial", 14))
        self.balance_label.pack()

    def add_income(self):
        try:
            income = float(self.income_entry.get())
            self.income += income
            self.update_balance()
            self.income_entry.delete(0, tk.END)
        except ValueError:
            messagebox.showwarning("Ошибка", "Введите корректное значение дохода!")

    def add_expense(self):
        category = self.expense_category_entry.get().strip()
        try:
            amount = float(self.expense_amount_entry.get())
            if category == "":
                messagebox.showwarning("Ошибка", "Введите категорию расхода!")
                return
            if category in self.expenses:
                self.expenses[category] += amount
            else:
                self.expenses[category] = amount
            self.update_balance()
            self.expense_category_entry.delete(0, tk.END)
            self.expense_amount_entry.delete(0, tk.END)
        except ValueError:
            messagebox.showwarning("Ошибка", "Введите корректное значение расхода!")

    def update_balance(self):
        total_expenses = sum(self.expenses.values())
        balance = self.income - total_expenses
        self.balance_label.config(text=f"Баланс: {balance:.2f} ₽")

    def plot_expenses(self):
        if not self.expenses:
            messagebox.showwarning("Ошибка", "Нет расходов для отображения!")
            return

        df = pd.DataFrame(list(self.expenses.items()), columns=['Категория', 'Сумма'])
        df.plot(kind='bar', x='Категория', y='Сумма', legend=False)
        plt.ylabel('Сумма (₽)')
        plt.title('Распределение расходов')
        plt.xticks(rotation=45)
        plt.tight_layout()  # Уплотнение графика для лучшего отображения
        plt.show()

if __name__ == "__main__":
    root = tk.Tk()
    budget_manager = BudgetManager(root)
    root.mainloop()
