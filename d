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
