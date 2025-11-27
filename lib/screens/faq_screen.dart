import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34CB79),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Dúvidas Frequentes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQItem(
            'O que é o Ecoleta?',
            'O Ecoleta é uma plataforma que conecta pessoas a pontos de coleta de materiais recicláveis em Palmas, Tocantins. Facilitamos o descarte consciente de resíduos.',
          ),
          _buildFAQItem(
            'Como funciona o Ecoleta?',
            'Você pode visualizar no mapa os pontos de coleta próximos a você, ver quais materiais cada ponto aceita e entrar em contato diretamente com eles através do chat.',
          ),
          _buildFAQItem(
            'Quais materiais posso reciclar?',
            'Os pontos de coleta aceitam diversos materiais como papel, papelão, plástico, vidro, metal, eletrônicos, pilhas, baterias e muito mais. Consulte cada ponto para detalhes específicos.',
          ),
          _buildFAQItem(
            'Como adiciono um ponto de coleta?',
            'Apenas usuários administradores podem adicionar pontos de coleta. Se você possui um ponto de coleta e quer cadastrá-lo, entre em contato conosco.',
          ),
          _buildFAQItem(
            'Preciso criar uma conta?',
            'Para visualizar os pontos de coleta e materiais, não é necessário criar uma conta. Porém, para usar o chat e entrar em contato com os pontos, você precisa estar logado.',
          ),
          _buildFAQItem(
            'Como funciona o chat?',
            'Após fazer login, você pode clicar em qualquer ponto de coleta e iniciar uma conversa para tirar dúvidas sobre horários, materiais aceitos e outras informações.',
          ),
          _buildFAQItem(
            'Os pontos de coleta funcionam aos finais de semana?',
            'O funcionamento varia de acordo com cada ponto de coleta. Consulte os detalhes de cada ponto ou entre em contato através do chat para confirmar os horários.',
          ),
          _buildFAQItem(
            'Posso doar outros itens além de recicláveis?',
            'Alguns pontos de coleta também aceitam doações de roupas, móveis e outros itens. Verifique com cada ponto através do chat ou das informações de contato.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF34CB79),
            ),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
