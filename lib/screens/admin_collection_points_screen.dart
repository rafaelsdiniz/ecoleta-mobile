import 'package:flutter/material.dart';
import '../models/ponto_coleta.dart';
import '../models/material.dart' as mat;
import '../services/api_service.dart';
import '../models/telefone.dart';
import '../models/dia_funcionamento.dart';
import '../models/horario_funcionamento.dart';

class AdminCollectionPointsScreen extends StatefulWidget {
  const AdminCollectionPointsScreen({super.key});

  @override
  State<AdminCollectionPointsScreen> createState() =>
      _AdminCollectionPointsScreenState();
}

class _AdminCollectionPointsScreenState
    extends State<AdminCollectionPointsScreen> {
  List<PontoColeta> _collectionPoints = [];
  List<mat.Material> _allMaterials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final points = await ApiService.getPontosColeta();
    final materials = await ApiService.getMateriais();
    setState(() {
      _collectionPoints = points;
      _allMaterials = materials;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34CB79),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Gerenciar Pontos de Coleta',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _collectionPoints.length,
                itemBuilder: (context, index) {
                  final point = _collectionPoints[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      point.nome,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      point.endereco,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    if (point.email != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        point.email!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Editar'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete,
                                            size: 20, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Excluir',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditDialog(point);
                                  } else if (value == 'delete') {
                                    _showDeleteDialog(point);
                                  }
                                },
                              ),
                            ],
                          ),
                          if (point.materiais.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: point.materiais.map((item) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF34CB79)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.nome,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF34CB79),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        backgroundColor: const Color(0xFF34CB79),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Adicionar Ponto',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => _PontoColetaFormDialog(
        materials: _allMaterials,
        onSave: (ponto) async {
          final created = await ApiService.createPontoColeta(ponto);
          if (created != null) {
            _loadData();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ponto de coleta adicionado com sucesso!'),
                  backgroundColor: Color(0xFF34CB79),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showEditDialog(PontoColeta point) {
    showDialog(
      context: context,
      builder: (context) => _PontoColetaFormDialog(
        pontoColeta: point,
        materials: _allMaterials,
        onSave: (ponto) async {
          final updated = await ApiService.updatePontoColeta(point.id!, ponto);
          if (updated != null) {
            _loadData();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ponto de coleta atualizado com sucesso!'),
                  backgroundColor: Color(0xFF34CB79),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteDialog(PontoColeta point) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Ponto de Coleta'),
        content: Text('Deseja realmente excluir "${point.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ApiService.deletePontoColeta(point.id!);
              if (success) {
                _loadData();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ponto de coleta excluído com sucesso!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

class _PontoColetaFormDialog extends StatefulWidget {
  final PontoColeta? pontoColeta;
  final List<mat.Material> materials;
  final Function(PontoColeta) onSave;

  const _PontoColetaFormDialog({
    this.pontoColeta,
    required this.materials,
    required this.onSave,
  });

  @override
  State<_PontoColetaFormDialog> createState() => _PontoColetaFormDialogState();
}

class _PontoColetaFormDialogState extends State<_PontoColetaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _emailController;
  late TextEditingController _enderecoController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  
  List<int> _selectedMaterials = [];
  
  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.pontoColeta?.nome);
    _descricaoController = TextEditingController(text: widget.pontoColeta?.descricao);
    _emailController = TextEditingController(text: widget.pontoColeta?.email);
    _enderecoController = TextEditingController(text: widget.pontoColeta?.endereco);
    _latitudeController = TextEditingController(
      text: widget.pontoColeta?.latitude.toString() ?? '-10.184',
    );
    _longitudeController = TextEditingController(
      text: widget.pontoColeta?.longitude.toString() ?? '-48.334',
    );
    
    if (widget.pontoColeta != null) {
      _selectedMaterials = widget.pontoColeta!.materiais.map((m) => m.id!).toList();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _emailController.dispose();
    _enderecoController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.pontoColeta == null
          ? 'Adicionar Ponto de Coleta'
          : 'Editar Ponto de Coleta'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude *',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Materiais Aceitos:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.materials.map((material) {
                  final isSelected = _selectedMaterials.contains(material.id);
                  return FilterChip(
                    label: Text(material.nome),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedMaterials.add(material.id!);
                        } else {
                          _selectedMaterials.remove(material.id);
                        }
                      });
                    },
                    selectedColor: const Color(0xFF34CB79).withOpacity(0.3),
                    checkmarkColor: const Color(0xFF34CB79),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final selectedMaterials = widget.materials
                  .where((m) => _selectedMaterials.contains(m.id))
                  .toList();
              
              final ponto = PontoColeta(
                id: widget.pontoColeta?.id,
                nome: _nomeController.text,
                descricao: _descricaoController.text.isEmpty 
                    ? null 
                    : _descricaoController.text,
                email: _emailController.text.isEmpty 
                    ? null 
                    : _emailController.text,
                endereco: _enderecoController.text,
                latitude: double.parse(_latitudeController.text),
                longitude: double.parse(_longitudeController.text),
                materiais: selectedMaterials,
              );
              
              widget.onSave(ponto);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34CB79),
            foregroundColor: Colors.white,
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
