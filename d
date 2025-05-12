import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime
import json
import os

class BudgetApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Ведение бюджетов")
        self.root.geometry("800x600")
        
        # Инициализация данных
        self.transactions = []
        self.categories = ["Еда", "Транспорт", "Жилье", "Развлечения", "Здоровье", "Одежда", "Другое"]
        self.budget_limits = {category: 0 for category in self.categories}
        
        # Загрузка данных при запуске
        self.load_data()
        
        # Создание интерфейса
        self.create_widgets()
        
    def create_widgets(self):
        # Вкладки
        self.notebook = ttk.Notebook(self.root)
        self.notebook.pack(pady=10, fill='both', expand=True)
        
        # Вкладка добавления транзакций
        self.add_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.add_tab, text="Добавить транзакцию")
        
        # Вкладка просмотра транзакций
        self.view_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.view_tab, text="Просмотр транзакций")
        
        # Вкладка бюджета
        self.budget_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.budget_tab, text="Бюджет")
        
        # Вкладка статистики
        self.stats_tab = ttk.Frame(self.notebook)
        self.notebook.add(self.stats_tab, text="Статистика")

        # Заполнение вкладки добавления транзакции
        self.setup_add_tab()
        self.setup_view_tab()
        self.setup_budget_tab()
        self.setup_stats_tab()
    
    def setup_add_tab(self):
        # Тип транзакции (доход/расход)
        tk.Label(self.add_tab, text="Тип:").grid(row=0, column=0, padx=10, pady=5, sticky="e")
        self.trans_type = tk.StringVar(value="Расход")
        tk.Radiobutton(self.add_tab, text="Доход", variable=self.trans_type, value="Доход").grid(row=0, column=1, sticky="w")
        tk.Radiobutton(self.add_tab, text="Расход", variable=self.trans_type, value="Расход").grid(row=0, column=2, sticky="w")
        
        # Сумма
        tk.Label(self.add_tab, text="Сумма:").grid(row=1, column=0, padx=10, pady=5, sticky="e")
        self.amount = tk.DoubleVar()
        tk.Entry(self.add_tab, textvariable=self.amount).grid(row=1, column=1, columnspan=2, sticky="we", padx=10)
        
        # Категория
        tk.Label(self.add_tab, text="Категория:").grid(row=2, column=0, padx=10, pady=5, sticky="e")
        self.category = tk.StringVar()
        ttk.Combobox(self.add_tab, textvariable=self.category, values=self.categories).grid(row=2, column=1, columnspan=2, sticky="we", padx=10)

        # Дата
        tk.Label(self.add_tab, text="Дата:").grid(row=3, column=0, padx=10, pady=5, sticky="e")
        self.date = tk.StringVar(value=datetime.now().strftime("%Y-%m-%d"))
        tk.Entry(self.add_tab, textvariable=self.date).grid(row=3, column=1, columnspan=2, sticky="we", padx=10)
        
        # Описание
        tk.Label(self.add_tab, text="Описание:").grid(row=4, column=0, padx=10, pady=5, sticky="e")
        self.description = tk.StringVar()
        tk.Entry(self.add_tab, textvariable=self.description).grid(row=4, column=1, columnspan=2, sticky="we", padx=10)
        
        # Кнопка добавления
        tk.Button(self.add_tab, text="Добавить транзакцию", command=self.add_transaction).grid(row=5, column=1, pady=10)

    def setup_view_tab(self):
        # Фильтры
        filter_frame = ttk.LabelFrame(self.view_tab, text="Фильтры")
        filter_frame.pack(fill="x", padx=10, pady=5)
        
        tk.Label(filter_frame, text="Тип:").grid(row=0, column=0, padx=5, pady=2)
        self.filter_type = tk.StringVar(value="Все")
        ttk.Combobox(filter_frame, textvariable=self.filter_type, values=["Все", "Доход", "Расход"]).grid(row=0, column=1, padx=5, pady=2)
        
        tk.Label(filter_frame, text="Категория:").grid(row=0, column=2, padx=5, pady=2)
        self.filter_category = tk.StringVar(value="Все")
        ttk.Combobox(filter_frame, textvariable=self.filter_category, values=["Все"] + self.categories).grid(row=0, column=3, padx=5, pady=2)
        
        tk.Label(filter_frame, text="Дата от:").grid(row=1, column=0, padx=5, pady=2)
        self.filter_date_from = tk.StringVar()
        tk.Entry(filter_frame, textvariable=self.filter_date_from).grid(row=1, column=1, padx=5, pady=2)
        
        tk.Label(filter_frame, text="Дата до:").grid(row=1, column=2, padx=5, pady=2)
        self.filter_date_to = tk.StringVar()
        tk.Entry(filter_frame, textvariable=self.filter_date_to).grid(row=1, column=3, padx=5, pady=2)
        
        tk.Button(filter_frame, text="Применить", command=self.apply_filters).grid(row=1, column=4, padx=5, pady=2)

        # Таблица транзакций
        columns = ("id", "date", "type", "category", "amount", "description")
        self.transactions_tree = ttk.Treeview(self.view_tab, columns=columns, show="headings")
        
        self.transactions_tree.heading("id", text="ID")
        self.transactions_tree.heading("date", text="Дата")
        self.transactions_tree.heading("type", text="Тип")
        self.transactions_tree.heading("category", text="Категория")
        self.transactions_tree.heading("amount", text="Сумма")
        self.transactions_tree.heading("description", text="Описание")
        
        self.transactions_tree.column("id", width=30)
        self.transactions_tree.column("date", width=80)
        self.transactions_tree.column("type", width=70)
        self.transactions_tree.column("category", width=100)
        self.transactions_tree.column("amount", width=80)
        self.transactions_tree.column("description", width=200)
        
        scrollbar = ttk.Scrollbar(self.view_tab, orient="vertical", command=self.transactions_tree.yview)
        self.transactions_tree.configure(yscrollcommand=scrollbar.set)
        
        self.transactions_tree.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        
        # Кнопка удаления
        tk.Button(self.view_tab, text="Удалить выбранное", command=self.delete_transaction).pack(pady=5)

         # Обновление таблицы
        self.update_transactions_table()
    
    def setup_budget_tab(self):
        # Установка лимитов бюджета
        tk.Label(self.budget_tab, text="Установите месячные лимиты для категорий:").pack(pady=5)
        
        self.budget_entries = {}
        for i, category in enumerate(self.categories):
            frame = ttk.Frame(self.budget_tab)
            frame.pack(fill="x", padx=10, pady=2)
            
            tk.Label(frame, text=category, width=15).pack(side="left")
            self.budget_entries[category] = tk.DoubleVar(value=self.budget_limits[category])
            tk.Entry(frame, textvariable=self.budget_entries[category]).pack(side="left", fill="x", expand=True)
            tk.Label(frame, text="руб.").pack(side="left", padx=5)
        
        tk.Button(self.budget_tab, text="Сохранить лимиты", command=self.save_budget_limits).pack(pady=10)
        
        # Отображение текущего состояния бюджета
        tk.Label(self.budget_tab, text="Текущее состояние бюджета:").pack(pady=5)
        
        self.budget_status_text = tk.Text(self.budget_tab, height=10, state="disabled")
        self.budget_status_text.pack(fill="both", expand=True, padx=10, pady=5)
        
        self.update_budget_status()
    
    def setup_stats_tab(self):
        # Статистика по категориям
        tk.Label(self.stats_tab, text="Статистика по расходам по категориям:").pack(pady=5)
        
        self.stats_canvas = tk.Canvas(self.stats_tab)
        self.stats_canvas.pack(fill="both", expand=True, padx=10, pady=5)
        
        # Обновление статистики
        self.update_stats()
    
    def add_transaction(self):
        try:
            amount = self.amount.get()
            if amount <= 0:
                messagebox.showerror("Ошибка", "Сумма должна быть положительной")
                return
                
            transaction = {
                "id": len(self.transactions) + 1,
                "date": self.date.get(),
                "type": self.trans_type.get(),
                "category": self.category.get(),
                "amount": amount,
                "description": self.description.get()
            }
            
            self.transactions.append(transaction)
            self.save_data()
            self.update_transactions_table()
            self.update_budget_status()
            self.update_stats()
            
            messagebox.showinfo("Успех", "Транзакция добавлена успешно")
