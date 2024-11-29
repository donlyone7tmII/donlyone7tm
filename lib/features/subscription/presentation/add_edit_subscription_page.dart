import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:subscription_manager/features/subscription/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:logger/logger.dart'; // Import logger package

void main() {
  Subscription subscription = Subscription(
    id: 'sub123',
    name: 'Netflix Subscription',
    status: 'Active',
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    price: 12.99,
    description: 'Monthly subscription for Netflix',
  );

  runApp(MaterialApp(
    home: Scaffold(
      body: AddEditSubscriptionPage(
        subscription: subscription,
      ),
    ),
  ));
}

class AddEditSubscriptionPage extends StatefulWidget {
  final Subscription? subscription;

  const AddEditSubscriptionPage({super.key, this.subscription});

  @override
  State<AddEditSubscriptionPage> createState() => _AddEditSubscriptionPageState();
}

class _AddEditSubscriptionPageState extends State<AddEditSubscriptionPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;
  final Logger _logger = Logger(); // Logger instance for logging

  @override
  Widget build(BuildContext context) {
    // Determine whether we're adding or editing a subscription
    String appBarTitle =
        widget.subscription == null ? 'Add new subscription' : 'Edit subscription';
    String buttonLabel =
        widget.subscription == null ? 'Add Subscription' : 'Edit Subscription';

    // Initialize form field values, defaulting to the existing subscription if present
    final initialValues = {
      'name': widget.subscription?.name ?? '',
      'status': widget.subscription?.status ?? 'Inactive',
      'description': widget.subscription?.description ?? '',
      'startDate': widget.subscription?.startDate,
      'endDate': widget.subscription?.endDate,
      'price': widget.subscription?.price.toString() ?? '0.0',
    };

    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is SubscriptionAdded) {
          _logger.i("Subscription added"); // Log the addition
          Navigator.pop(context, "Subscription added");
        } else if (state is SubscriptionUpdated) {
          _logger.i("Subscription updated: ${state.newSubscription.id}"); // Log the update
          Navigator.pop(context, state.newSubscription);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(
          children: [
            Expanded(
                child: FormBuilder(
              key: _formKey,
              initialValue: initialValues,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  FormBuilderTextField(
                    name: 'name',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderDropdown(
                    name: 'status',
                    items: ['Active', 'Inactive']
                        .map((status) => DropdownMenuItem(
                            value: status, child: Text(status)))
                        .toList(),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Status',
                        hintText: 'Select status'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'description',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'startDate',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Start Date',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'endDate',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'End Date',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FormBuilderTextField(
                    name: 'price',
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                    ),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.positiveNumber(),
                    ]),
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: _isPerforming
                            ? null
                            : () {
                                bool isValid =
                                    _formKey.currentState!.validate();
                                final inputs =
                                    _formKey.currentState!.instantValue;

                                if (isValid) {
                                  setState(() {
                                    _isPerforming = true;
                                  });

                                  final newSubscription = Subscription(
                                    id: widget.subscription?.id ?? '', // Ensure ID is passed for update
                                    name: inputs['name'],
                                    status: inputs['status'],
                                    startDate: inputs['startDate'],
                                    endDate: inputs['endDate'],
                                    price: double.parse(inputs['price']),
                                    description: inputs['description'],
                                  );

                                  if (widget.subscription == null) {
                                    // Add new subscription
                                    context
                                        .read<SubscriptionCubit>()
                                        .addSubscription(newSubscription);
                                  } else {
                                    // Update existing subscription
                                    context
                                        .read<SubscriptionCubit>()
                                        .modifySubscription(newSubscription);
                                  }
                                }
                              },
                        child: _isPerforming
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ))
                            : Text(buttonLabel)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

