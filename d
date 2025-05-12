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
